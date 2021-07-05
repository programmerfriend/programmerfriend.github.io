---
layout: post
title: "Filtering JSON Response with SpringBoot and Jackson"
share-img: /img/content/springboot-json-filter-share.jpg
image: /img/content/springboot-json-filter-share.jpg
bigimg: /img/content/springboot-json-filter-title.jpg
permalink: /filtering-json-springboot
gh-repo: eiselems/springboot-field-filtering
gh-badge: [star, fork, follow]
tags: [spring-boot]
excerpt: "There are many APIs where you can specify the parts of the response you are really interested in. Let's have a look at how we could build such a filter with SpringBoot"
---

You might be ending here by a google search. I hope you find what you were coming for.
This article is about how to set up a SpringBoot Application to filter parts of the JSON response on the server-side.

This article is inspired by a requirement I had at work.
The approach has some downsides but it does exactly what it should, it allows a consumer to specify in which top-level elements he is interested in.

## What to expect?

We will implement a simple GET Operation that returns a DTO (Data Transfer Object, also POJO).
By adding a `fields` query parameter our consumers will be able to filter the top-level elements on the server-side.
The API will only return the fields the consumer asked for.

```bash
GET http://localhost:8080/users/99?fields=firstName,lastName
Accept: application/json

will give you:
{
  "firstName": "John",
  "lastName": "Doe"
}

instead of:
{
  "firstName": "John",
  "lastName": "Doe",
  "birthday": "1990-12-31",
  "profession": "Programmer",
  "createdAt": "2021-07-06T01:37:50.32079+02:00"
}
```

## Let's have a quick look at the application

Our application is a simple SpringBoot Application created with https://start.spring.io. Flavor for the tutorial will be Maven/Kotlin.

What I really like about the usage of Kotlin for tutorials is that Kotlin allows to have almost all of the implementation within a few files. Let's have a look:

```java
UserService.kt


@Service
class UserService {

    fun getUser(id: String): User {
        // in reality this comes from a DB
        return User(
            id = id,
            firstName = "John",
            lastName = "Doe",
            birthday = LocalDate.of(1990, Month.DECEMBER, 31),
            profession = "Programmer",
            createdAt = ZonedDateTime.now()
        )
    }
}

data class User(
    val id: String,
    val firstName: String,
    val lastName: String,
    val birthday: LocalDate,
    val profession: String,
    val createdAt: ZonedDateTime
)
```

```java
UserController.kt

@RestController
class UserController(
    val userService: UserService
) {
    @GetMapping("/users/{id}")
    fun getUser(@PathVariable("id") id: String) = UserDto.fromUser(userService.getUser(id))
}

data class UserDto(
    val firstName: String,
    val lastName: String,
    val birthday: LocalDate,
    val profession: String,
    val createdAt: ZonedDateTime
) {
    companion object {
        fun fromUser(user: User) = UserDto(
            firstName = user.firstName,
            lastName = user.lastName,
            birthday = user.birthday,
            profession = user.profession,
            createdAt = user.createdAt
        )
    }
}
```

I also threw a `Configuration` class for our `ObjectMapper` into the mix since that never hurts.
This is doing more than needed for this tutorial, but I wanted to include some kind of sane configuration that you could also use for deserializing content. Most input here is for adding only non-null fields and to properly format the `createdAt` date of the user.

```java
@Configuration
class ObjectMapperConfiguration {

    @Primary
    @Bean
    fun configure() =
        ObjectMapper().apply {
            setSerializationInclusion(JsonInclude.Include.NON_EMPTY)
            configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
            configure(DeserializationFeature.FAIL_ON_NULL_FOR_PRIMITIVES, true)
            configure(DeserializationFeature.READ_UNKNOWN_ENUM_VALUES_USING_DEFAULT_VALUE, true)
            disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS)

            val javaTimeModule = JavaTimeModule().apply {
                this.addDeserializer(
                    LocalDateTime::class.java,
                    LocalDateTimeDeserializer(DateTimeFormatter.ISO_DATE_TIME)
                )
            }

            registerModules(javaTimeModule, KotlinModule())
        }
}
```

That is all for now. As you can see we have a typical three-tier architecture (Controller/Service/Repository). The repository is omitted since adding a database has no benefit for this tutorial.

The `/users/{id}` endpoint will return a `UserDto` that gets created based on the model the Controller receives from the Service. Hopefully, things are looking familiar.

We can quickly start the service and query
```
GET http://localhost:8080/users/99
Accept: application/json
```
which will return information about a User consisting of a lot of fields.

## Starting with what you came for

For our example, the Service Class will stay exactly the way it is. We will modify our Controller to only return the fields a consumer of our API provided.

### Add the query parameter

That is quite easy, isn't it? Just add:

```
@RequestParam(required = false, value = "fields") fields: String?
```

on top of our existing `GetMapping`. This adds an optional `field` query parameter that can get added at the end of the URL. I decided to make it optional since this won't affect the behavior of our API for existing API consumers - always something you should keep in mind.

Sadly the code will get a bit more verbose now, but this is the price we have to pay.

### Bring the pre-requisites into place
We will be using Jackson's `JsonFilter` functionality that allows us to remove parts while serializing our DTO. 

#### Let's add the annotation on top of our `UserDto`-class:

```java
const val FIELDS_FILTER = "FIELDS_FILTER"

@JsonFilter(FIELDS_FILTER)
data class UserDto(
...
```

Having the name of the filter in a constant is in general a good idea. It prevents errors by mistyping in other places.

#### Use MappingJacksonValue to filter our response

`MappingJacksonValue` is a wrapper for DTOs that allows many operations on top of them. One of them is adding filters.

We will add a `filterOutAllExcept`-filter in case the `fields`-parameter we added earlier is populated.
There we will pass the fields we received in our call as a `Set`. This needs to get wrapped with a `SimpleFilterProvider` for which we need to add our filter. Have a look below, i think the code might be easier to read than the text here.

```java
@GetMapping("/users/{id}")
    fun getUser(
        @PathVariable("id") id: String,
        @RequestParam(required = false, value = "fields") fields: String?
    ): MappingJacksonValue {

        val fromUser = UserDto.fromUser(userService.getUser(id))

        val mappingJacksonValue = MappingJacksonValue(fromUser)

        if (!fields.isNullOrEmpty()) {
            mappingJacksonValue.filters =
                SimpleFilterProvider().addFilter(
                    FIELDS_FILTER,
                    SimpleBeanPropertyFilter.filterOutAllExcept(fields.split(",").toSet())
                )
        }
        return mappingJacksonValue
    }
```

The only thing that is not perfect: Once your DTO has a `JsonFilter` annotation, you are required to apply a filter in all cases. This means for us that even if we don't get a filter, we still need to apply SOME filter to our response. The implementation above is dealing with the requirement to only return the fields given in the `fields` parameter.

### Let's take it for a test run

Start our application and tinker around with the request.
Let's take the request from before and add a fields parameter:

```java
GET http://localhost:8080/users/99?fields=firstName,lastName
Accept: application/json
```

will exactly return:

```
{
  "firstName": "John",
  "lastName": "Doe"
}
```

Awesome. Let's remove the fields parameter again from our request and see what happens.
What happens when we invoke our application?

We receive an HTTP 500 with the following exception:

```
InvalidDefinitionException: Cannot resolve PropertyFilter with id 'FIELDS_FILTER'; no FilterProvider configured
```

This is what I was talking about earlier, that for all cases there needs to be a filter.
Before you start to modify your controller - I got another solution.

I added the following block of code to the `ObjectMapperConfiguration`:

```
// this filter allows to have a JSON Filter Annotation on top of a DTO and be able to serialize it without extra handling
setFilterProvider(SimpleFilterProvider().apply {
    this.defaultFilter = SimpleBeanPropertyFilter.serializeAll()
})
```

This applies a `serializeAll` filter as default filter for all requests that had no filter applied.
In effect: Every time we have our MappingJacksonValue not getting a filter applied, it will just return all fields.

Awesome!

## What we achieved

We added a `filter` parameter to our API that allows consumers to filter the response in advance.
This has benefits for the size of the payload. Our requirement was data protection, our consumers should be able to prevent receiving data they don't need. Especially user data is really sensitive!

## Limitations / Known issues

In my opinion, this approach has two small issues:
1. The filtering is only applied on the Controller level - your service still has to work in order to fetch all the required information. For this minimal example, it is not an issue. It could be one if the DTO in question is rather large and a bit more expensive to calculate.
2. Filtering only works for top-level fields. That was not an issue for our use case but it could be for you. If you need more advanced field filters for nested objects. There are a few projects on Github just giving you that, or maybe you could have a look at `GraphQL`.

## Closing

I hope you liked the article and could learn something from it. I was quite impressed how neat the implementation turned out. Things can be really awesome if they just work.

You can leave a comment here or reach out on Twitter.<br><a href="https://twitter.com/intent/tweet?screen_name=eiselems&ref_src=twsrc%5Etfw" class="twitter-mention-button" data-size="large" data-text="Filtering JSON Responses with SpringBoot:   #programmerfriend" data-related="eiselems" data-show-count="false">Tweet to @eiselems</a><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

All the source code can be found within the [Github Repository](https://github.com/eiselems/springboot-field-filtering).