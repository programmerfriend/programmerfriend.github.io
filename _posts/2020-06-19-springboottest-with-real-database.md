---
layout: post
title: "Testcontainers: Test Your Spring Boot Application with a Real Database"
share-img: /img/content/test-containers-boot-real-database_share.jpg
image: /img/content/test-containers-boot-real-database_share.jpg
bigimg: /img/content/test-containers-boot-real-database_title.jpg
permalink: /testcontainers-springboot-real-database
gh-repo: eiselems/boot-testcontainers
gh-badge: [star, fork, follow]
tags: [developers, soft-skills]
excerpt: "Testcontainers is an awesome library. But not every Java Developer is aware of its existence. Let's see how we can use a dockerized PostgreSQL database for the Integration Test of our Spring Boot Application"
---

This article is inspired by a quick chat I had today with a colleague.
He is a very experienced Java Developer whom I respect for his knowledge.

*Still ...* he hasn't heard about Testcontainers.

## What are Testcontainers exactly?

Let's cut to the chase. [Testcontainers](https://www.testcontainers.org/) is a Java Library that supports Java Tests by providing anything that can run inside a docker container. Databases, Selenium, Message Brokers, or other Services - you name it.

## My Killer Use-Case: What I use it for

A common pain point I saw when developing Spring Boot Applications was that I often encountered a discrepancy between the software we use on production and the software we use for running our tests.

A quick example that comes to my mind: Us using an embedded H2 for our tests versus running MySQL or PostgreSQL on production. This approach is fine - until it isn't.

*In theory:* All of these databases use SQL as query language. *In practice:* All of them have a slightly different dialect. As soon as you deal with indices or special datatypes - you are out.

From now on, you will be accepting that you need to write custom database migrations just for your tests, or you test your database migrations not at all (at least until they hit the dev stage).

But there is an alternative. What if I tell you that you could use the same type of database for your tests as you run on production? Sounds awesome, doesn't it?

## How to achieve this

Let's assume for a moment that we have a Spring Boot Application that relies on a database to deliver some content via a REST interface. On production, the Application connects to a `postgresql 11.x` service managed by your cloud provider.

For the examples, we will use the Kotlin Programming Language. I hope you don't mind.
The Java version should look pretty similar since the important steps are in the configuration anyway (sorry for the spoiler).

### Bring the database in place first:

(I assume you have Docker installed). According to [Dockerhub: Postgres](https://hub.docker.com/_/postgres/) we can bring up a PostgreSQL database by running:
```
    docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -d postgres:11.7-alpine
```

For this tutorial, I have chosen an image containing version 11.7 based on the alpine docker image.

Now a PostgreSQL database should be running on port 5432.

### Setup your service

I don't want to get into detail on how to create the code here. I will just show it to you and quickly talk about it.
I put everything into one file for the convenience of the tutorial.

The service was created by using the Spring Boot Starter on https://start.spring.io and selecting Kotlin as language and adding the dependencies `Spring Web`, `Spring Data JPA`, `PostgreSQL Driver`. As build tool I used the default - Maven.


```kotlin
@RestController
class ExampleRestController(val personService: PersonService) {

    @GetMapping("/persons")
    fun getPerson(): List<PersonDto> {
        return personService.getAllPersons()
                .map { personModel -> PersonDto.fromModel(personModel) };
    }
}

data class PersonDto(val name: String) {
    companion object {
        fun fromModel(person: Person) = PersonDto(person.name)
    }
}

@Service
class PersonService(private val personRepository: PersonRepository) {
    fun getAllPersons(): List<Person> = personRepository.findAll()

    @PostConstruct
    fun prepareDatabase() {
        personRepository.deleteAll()
        personRepository.save(Person(name = "Marcus Eisele"))
        personRepository.save(Person(name = "John Doe"))
    }
}

interface PersonRepository : JpaRepository<Person, Number>

@Entity
data class Person(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Int? = null,

        @Column(nullable = false)
        val name: String
)
```

So, what do we have here? I would say a typical Controller > Service > Repository application.
It successfully encapsulates the Controller Tier from the Service Tier by having DTO and Entity classes.

We used a `@PostConstruct` within the service to populate the database with data.

When we would start the service now, it would crash because we didn't set up the connection to the Postgres database correctly. Let's do that now.

Open the `application.properties` file and add

```
## PostgreSQL
spring.datasource.url=jdbc:postgresql://localhost:5432/postgres
spring.datasource.username=postgres
spring.datasource.password=mysecretpassword

#drop n create table again, good for testing, comment this in production
spring.jpa.hibernate.ddl-auto=create-drop
```

We have used the parameters from booting up the docker container and also setup hibernate to recreate the table definitions every application run. This is just fine for our use-case here. On production, you probably should use a Data Migration tool like [Flyway](https://flywaydb.org/) or [Liquibase](https://www.liquibase.org/).

When we start the application now, it should boot up and be serving JSON-content on http://localhost:8080/persons. If it crashes, make sure that there is not anything else running on `port 8080`.

### Testing your service

Cool, the implementation works! But what would be a proper implementation without a test?

Ok, we all know how to do this - let's write a quick `@SpringBootTest` which verifies that our application works.

```kotlin
@ActiveProfiles("integration")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class AwesomeTestcontainersApplicationTests() {

    @LocalServerPort
    var randomServerPort = 0

    var restTemplate = TestRestTemplate()
    var headers: HttpHeaders = HttpHeaders()


    @Test
    fun returnsListOfPersons() {
        val entity = HttpEntity<String>(null, headers)

        val response = restTemplate.exchange(
                createURLWithPort("/persons"),
                HttpMethod.GET, entity, String::class.java)

        val expected = "[{name:\"Marcus Eisele\"},{name:\"John Doe\"}]"

        JSONAssert.assertEquals(expected, response.body, false)
    }

    private fun createURLWithPort(uri: String): String {
        return "http://localhost:$randomServerPort$uri"
    }
}
```

The `@ActiveProfiles` for now is optional - we gonna use it later.

Let's run the test and see what happens. It is green!
That is the proof that our service works!

But why is it green? We didn't set up a database, still the service returns correct data.

Some of you probably didn't fail for the bait - we didn't stop our database. The tests were running on our dockerized database we were using earlier. Let's stop it by executing `docker stop some-postgres`.

When we run our tests again, we can see that it fails. The application fails to connect to the database.

### Testcontainers to the rescue

Setting up a Testcontainer database and connecting via JDBC is a piece of cake.

There are two simple steps involved:

**Step 1:** Adding the *Testcontainers dependencies*.<br>
I used version 1.14.1 by adding the following line `<testcontainers.version>1.14.1</testcontainers.version>` by to the properties section of the `pom.xml`.

In the dependencies section of the `pom.xml` add the following two dependencies, they are test-scoped since they only will be used for our tests and not the implementation.

```
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>testcontainers</artifactId>
    <version>${testcontainers.version}</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>postgresql</artifactId>
    <version>${testcontainers.version}</version>
    <scope>test</scope>
</dependency>
```

As we already added an `@ActiveProfiles` for our integration profile, we can now add a configuration for our test.

**Step 2:** Adding the *Test Configuration*.<br>
Since the Profile used for the tests is called "integration" - the config has to go into the `application-integration.properties` file. Since again, it is only used for the tests, create the file within `/src/test/resources/`.

Inside that file we add the following line:

```
spring.datasource.url=jdbc:tc:postgresql:11.7-alpine:///
```

**Be aware:** It is postgres**ql** not postgres. The word postgresql is an identifier for testcontainers to use postgresql and not the image name.

**What happens here?**

Black magic. Just kidding, we have overwritten the `spring.datasource.url` define in our `application.properties` file. The database engine here is set to `tc` which is not a real database engine.
It is a marker for the testcontainers integration to bring up a container when the application context is getting started. The testcontainers integration is not only starting a container, but it is also updating `JDBC` to contain all information necessary to connect to it.

After adding the dependencies and creating the configuration, let's start the previously failed tests again.

AAAAAND it is green 🟢.

## What we achieved

We used Testcontainers to test our Spring Boot Application with a real database. The test is still self-contained, we don't need to set up anything outside of the test case itself (besides having docker).

This is huge! You can now test everything you do with the database.
Migrations, data mapping - just everything.

At least for me, these kinds of tests create a feeling of safety. With them, we should have much fewer issues compared to running an embedded H2 or even mocking the repository/database layer.

I hope you liked the article and could learn something from it. I am a big fan of Testcontainers and hope you soon will be too.

You can leave a comment here or on Twitter.<br><a href="https://twitter.com/intent/tweet?screen_name=eiselems&ref_src=twsrc%5Etfw" class="twitter-mention-button" data-size="large" data-text="My experience:   #programmerfriend #peopleSoftware" data-related="eiselems" data-show-count="false">Tweet to @eiselems</a><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>