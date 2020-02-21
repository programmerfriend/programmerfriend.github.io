---
layout: post
title: "Worst MockMvc Test Antipattern: Don't use ObjectMapper!"
bigimg: /img/content/worst-mock-mvc-antipattern_title.jpg
share-img: https://programmerfriend.com/img/content/worst-mock-mvc-antipattern_share.png
tags: [spring, spring-boot, tests, integration-testing]
---

Hi again,

as already promised on my Twitter Account:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Just realized that a bug fix I had in mind will make me sweat and probably takes longer than expected. All of that due to &quot;problematic&quot; test cases. I have a feeling that there will be a new blog post soon. 😅</p>&mdash; Marcus Eisele (@eiselems) <a href="https://twitter.com/eiselems/status/1229880536824500224?ref_src=twsrc%5Etfw">February 18, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

here comes my ~~rant~~ post about a certain way of writing Integration Tests with MockMvc and why I consider it a bad practice.

For the first time on any programmerfriend.com post, I want to use Kotlin examples, I hope you don't mind. Let's see how this goes.

## The offender

Let's assume we have `RestController` that just maps data it receives  e.g.

```Java
@RestController
class ExampleController {

    @PostMapping("/example/{path}/{id}")
    fun getExampleResponse(
        @PathVariable("path") path: String,
        @PathVariable("id") id: Int,
        @RequestBody body: ExampleRequest
    ) = ExampleResponse(path = path, someNumber = id, query = body.content)
}

data class ExampleRequest(val content: String)

data class ExampleResponse(val path: String, val someNumber: Int, val query: String)
```

This Controller maps the data it receives via `PathVariables` and `RequestBody` onto another Object and returns it.

Let's run this and try it out!

```sh
#!/usr/bin/env bash
curl -H "Content-Type: application/json" --data '{"content":"this is some content"}' -X POST http://localhost:8080/example/test/1

#should print: {"path":"test","someNumber":1,"query":"this is some content"}
```

Cool so far, we have finished our implementation. Now we gonna write an awesome Test for it.

If you are used to writing MockMvc Tests, this shouldn't make you sweat:

```java
@WebMvcTest(ExampleController::class)
@AutoConfigureMockMvc
internal class ExampleControllerTest {

    @Autowired
    private lateinit var mockMvc: MockMvc

    @Autowired
    private lateinit var objectMapper: ObjectMapper

    @Test
    fun getExampleResponse_givenValidRequest_shouldReturnMappedObject() {
        val content = "This is the content"
        val path = "MYPATH"
        val id = 1337

        val payload = ExampleRequest(content)

        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/example/$path/$id")
                    .content(objectMapper.writeValueAsBytes(payload))
                    .contentType(MediaType.APPLICATION_JSON)
            )
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.path").value(path))
            .andExpect(MockMvcResultMatchers.jsonPath("$.someNumber").value(id))
            .andExpect(MockMvcResultMatchers.jsonPath("$.query").value(content))

    }
}
```

My first impression about the Test for the happy case here: Awesome!
We build a JSON for our RequestObject, we send it via `POST` to the endpoint, we validate that the `Response` is looking like we expect it to look.

## So what is wrong with it?

There is nothing too wrong with writing tests like that. The thing here is that the test could cover so much more without much effort.
I really don't like using `ObjectMapper` to build the Request Object. You know why?

When we build the Object like that - there is no regression testing involved. The test will not catch any modification to the API definition. When we have Clients relying on the stability of our API it could hurt.

You might be saying that this might not be the scope of MockMvc tests and you could be potentially right - I just challenge you right here and ask 'Why not?'. Let's see the alternatives:

```java
@WebMvcTest(ExampleController::class)
@AutoConfigureMockMvc
internal class ExampleControllerTestAlternative {

    @Autowired
    private lateinit var mockMvc: MockMvc

    @Test
    fun getExampleResponse_givenValidRequest_shouldReturnMappedObject() {
        val content = "This is the content"
        val path = "MYPATH"
        val id = 1337

        val payload = """{"content": "$content"}"""

        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/example/$path/$id")
                    .content(payload)
                    .contentType(MediaType.APPLICATION_JSON)
            )
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.path").value(path))
            .andExpect(MockMvcResultMatchers.jsonPath("$.someNumber").value(id))
            .andExpect(MockMvcResultMatchers.jsonPath("$.query").value(content))

    }
}
```

Wow, almost no difference!

> Marcus, you are such a hypocrite. For no additional benefit, you made me use String literals. You know what kind of mess this becomes when there is a more complex Request Object?
>
> \> Somebody

I had a similar discussion a few months back at work when I raised my concerns in a Code Review.

So let me show you what the differences are.
Let's have both Test Classes in our project and just modify the implementation for now. In theory, they test the same thing right?

### Adding a new field to the Request Object

Let's make this quick, we want to add a new field because or API is evolving. The body should now also carry a number.

Replace our ExampleRequest with the new version:

```java
data class ExampleRequest(val content: String, val number: Int)
```

#### What happens?

The first version of our Tests does not compile, while the second does.

You might be thinking that the fact that the test does not compile is good. Well, it depends.

Two things:

For me, this non-compilation often drives people to just fix it in the code. It is just too easy to add another field in the test and make it compile again. After adding the new parameter - BOOM the test compiles and is green again.

Let's have a look at our updated test with the new `bodyNumber`.


```java
@Test
    fun getExampleResponse_givenValidRequest_shouldReturnMappedObject() {
        val content = "This is the content"
        val path = "MYPATH"
        val id = 1337
        val bodyNumber = 123

        val payload = ExampleRequest(content, bodyNumber)

        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/example/$path/$id")
                    .content(objectMapper.writeValueAsBytes(payload))
                    .contentType(MediaType.APPLICATION_JSON)
            )
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.path").value(path))
            .andExpect(MockMvcResultMatchers.jsonPath("$.someNumber").value(id))
            .andExpect(MockMvcResultMatchers.jsonPath("$.query").value(content))

    }
```

Ok, let's run both tests ...
<figure>
  <img src="{{site.url}}/img/content/worst-mock-mvc-antipattern_content_green_tests.png" alt="All tests passed inside our IDE"/>
</figure>

How could it be that the test second test is green?

After thinking about it ... the Integer will be initialized as 0.
We also will not need that value for our response, therefore we do not verify it.

Also, if we run the service again and test our curl command from above, even the new version is still able to serve it.
What else can we do to our service?

### Removing a field from the body

Let's change the implementation and use the just added `bodyNumber` instead of the `content` for our response.
Because we will no longer need the `content` field, let us also delete it.

```java
@RestController
class ExampleController {

    @PostMapping("/example/{path}/{id}")
    fun getExampleResponse(
        @PathVariable("path") path: String,
        @PathVariable("id") id: Int,
        @RequestBody body: ExampleRequest
    ) = ExampleResponse(path = path, someNumber = id, query = body.number.toString())
}

//data class ExampleRequest(val content: String)
//data class ExampleRequest(val content: String, val number: Int)
data class ExampleRequest(val number: Int)

data class ExampleResponse(val path: String, val someNumber: Int, val query: String)
```

I don't want to get into too much detail here, the tests behave very similarly here.
Both need to get adjusted because of the payload and both need to be adjusted for the verification step.

If you want to check what changes were needed have a look at: https://github.com/eiselems/spring-test-antipattern/commit/066c6d01919b410ee73e757c71eb1cfdb5c6891b

So what is the matter?

Now, I question you to write a test that verifies that the old call is still working correctly.

Let's start with the alternative which is using JSON:

```java

    @Test
    fun getExampleResponse_givenOldRequest_shouldAlsoGiveReturnObject() {
        val content = "This is the content"
        val path = "MYPATH"
        val id = 1337

        val payload = """{"content": "$content"}"""

        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/example/$path/$id")
                    .content(payload)
                    .contentType(MediaType.APPLICATION_JSON)
            )
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.jsonPath("$.path").value(path))
            .andExpect(MockMvcResultMatchers.jsonPath("$.someNumber").value(id))
            .andExpect(MockMvcResultMatchers.jsonPath("$.query").value(content))
    }
```

When we run this test, we will get an error:

```
java.lang.AssertionError: JSON path "$.query" expected:<This is the content> but was:<0>
Expected :This is the content
Actual   :0
```

Ok, cool. We just verified that the call is not working anymore because we will not get the content back as before.
I like doing these kind of things to correctly verify "What would happen if we change the callers to modify the requests".

Let's do this operation with our first test.

And here comes the **Showstopper** - It is not possible. You can not add a field to a Data Object that is not there.
Due to this, you can't test Annotations like `@JsonIgnoreProperties(ignoreUnknown = true)` which allow ignoring additional attributes when deserializing your RequestBodies. If you want to test such things, the only way is the JSON way.

## Other benefits

Another consideration worth mentioning is that you always can externalize these `Request`-JSONs.
When they are externalized they don't clutter your code and you have an easy way to look up how exactly your requests should look. These files are in my opinion the best documentation in your code that you can have.

If you write tests this way, they are also always verifying the JSON Deserializers you use in your RestControllers.
When these kinds of tests are green, there is no doubt that it will work later when using any sort of HTTP Client.

# Recap

For me using `ObjectMapper` to construct request objects is not the best thing you can do. Using JSON directly is more versatile and handy when you want to try out different things for API versioning or just error handling. When you do this right, there is almost no reason to really start your Spring Boot Application and test things manually, it is the same as using a REST client.

This topic might be highly opinionated. So, do you agree? Feel free to tell me. Do you disagree - PLEASE tell me!

You can leave a comment here or on Twitter.<br><a href="https://twitter.com/intent/tweet?screen_name=eiselems&ref_src=twsrc%5Etfw" class="twitter-mention-button" data-size="large" data-text="My opinion in tests: #programmerfriend #Objectmapper" data-related="eiselems" data-show-count="false">Tweet to @eiselems</a><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>