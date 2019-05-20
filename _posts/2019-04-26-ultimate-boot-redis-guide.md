---
layout: post
title: "Spring Boot Redis: Ultimate Guide to Redis Cache with Spring Boot 2"
image: /img/content/robust-boot_title.png
bigimg: /img/content/robust-boot_title.png
permalink: /ultimate-guide-to-redis-cache-with-spring-boot-2-and-spring-data-redis/
gh-repo: eiselems/ultimate-redis-boot
gh-badge: [star, fork, follow]
tags: [spring-boot, redis]
---

Since it has been a while since I wrote my article about [‘How We Made Our Spring Boot Applications More Robust with Redis Cache and Spring AOP‘]({% post_url 2019-01-16-more-robust-boot-with-redis-cache-and-spring-aop %}), I now want to write the Ultimate Guide on getting started with Redis Cache and Spring Boot 2.

During my last 2 years at work, I would say a lot of our current architecture is only possible by using Caching. At the center of this is Spring Boot together with Redis. In this Guide I want to give you the same powerful tools for your current and future Implementations.

To give you a short summary what we are about to do:

1. Setting up the Redis Cache on your machine
1. Writing a Spring Boot Application
1. Use Spring’s Integrated @Cacheable Annotation to cache results of method invocations using Spring Data Redis
1. Gain more fine granular control by using the other available Annotations
1. Create dynamic CacheKeys: Cache depending on the input parameters of our methods
1. Define after what time (TTL=time-to-live) our cached Entries are not valid anymore
1. Define different TTLs

# Lets get started – Redis Installation Guide
There are many ways of installing Redis on your machine.
I would advice you to go to https://redis.io/topics/quickstart and have a try on your own.

For all the people who don’t want to get off this page right now:

## Mac OS:

Assuming you have homebrew installed:

```
brew install redis
```

Alternatively (also working on many Linux distros):

```
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
```

After you have done it either way, you should be able to run redis-server and redis-cli.
In order to verify that you have done it correctly try to run:

```
$ redis-cli ping
PONG
```

*PONG* is the reply by the server, which means you were successful and your server is up and running.
In case you get an error like 
```
Could not connect to Redis at 127.0.0.1:6379: Connection refused.
```

Make sure that redis-server is running and maybe go to: [https://redis.io/topics/quickstart](https://redis.io/topics/quickstart) for troubleshooting.

# Spring Boot 2 Cache Application
Now that we dealt with the “Infrastructure”: Let’s go for our service implementation using Spring Boot 2.

In case you need any help, or a quick sneak peek: The whole code is available on the [GitHub-Repository](https://github.com/eiselems/ultimate-redis-boot).

## 1. Create our Spring Boot Redis Caching Service
In 1.1. we will generate our Service independent from an IDE in 1.2 we will be using IntelliJ Idea (just to show you both ways and to be IDE-agnostic)

### 1.1 Head over to [https://start.spring.io](https://start.spring.io) and create a Spring Boot Service
Let’s add the dependencies **Redis**, **Cache** and **Lombok**. The last one is really optional, but I like to include it in most of my java projects since it makes our whole codebase much less verbose. It is providing helpful annotations like *@NoArgsConstructor*, *@AllArgsConstructor* and *@Data* instead of generating getters and setters in our code itself. If you want to run without it – no issue at all, it might just be that in some places you need to generate a few more methods.

Also make sure to give your project a nice name, I went with *com.programmerfriend* as group and *ultimate-redis* as Artifact name.

Adding the Redis and Cache dependency to our new project here will add the *spring-boot-starter-data-redis* and *spring-boot-starter-cache* as dependencies to our service.

We just created a Spring Boot Service using Redis as a Cache.

### 1.2 Open up IntelliJ IDEA
If you are using IntelliJ IDEA, you also can just use the initializer from within IDEA itself.

*Create new project -> Spring Initializr.*
Here you have the same possibilities. The result is a project opened in your IDE having all the necessary dependencies.

### Connect our Spring Boot Service to our local Redis Cache
Let’s hope our local Redis Cache installation is working and start connecting our Spring Boot Service to the local instance.

Luckily, the initializer has already done most of the work for us.

What I did to get started is to create a class called CacheService which has a single method cacheThis.
We also put a *@Cacheable-Annotation* with a proper cache name on top of it.

```java
@Slf4j
@Service
public class CacheService {

    @Cacheable(cacheNames = "myCache")
    public String cacheThis(){
        log.info("Returning NOT from cache!");
        return "this Is it";
    }
}
```

Now I switched over to the *Application.class* and implemented the *CommandLineRunner* Interface. This is done to have a method where we can test the things we will implement without spending time writing a REST Interface or Integration Tests.

What we are trying to do now: Invoke our CacheService twice and see that we actually only execute the method once.

In order to do this, we implement the run method (brought by the *CommandLineRunner* Interface) like the following:

```java
//God almighty forgive me for doing field injection
@Autowired
CacheService cacheService;

...

@Override
public void run(String... args) throws Exception {
    String firstString = cacheService.cacheThis();
    log.info("First: {}", firstString);
    String secondString = cacheService.cacheThis();
    log.info("Second: {}", secondString)
}
```

Now that we have done this: <br>
Start the application and see how easy all of this was (mvn spring-boot:run is your friend for running a Spring Boot Application). Alternatively you can run this from your IDE.

**What do we expect?**
Yes, something like:

```
Returning NOT from cache!
First: This is it!
Second: This is it!
```

And what do we get?

```
Returning NOT from cache!
First: This is it!
Returning NOT from cache!
Second: This is it!
```

**Ouf! What went wrong?**
What I also quite often forget is to add another annotation: @EnableCaching.
For this tutorial we just add it to our application class

After adding this, start the Spring Boot application again:

```
Returning NOT from cache!
First: This is it!
Second: This is it!
Ah, finally!
```

*Sidenote:* If you run it multiple times don’t be surprised if `Returning NOT from cache!` goes away. It might be that your Redis Cache is still containing the value. You can flush the cache by using `redis-cli flushall` and then run it again. 
In our current setup, the keys never get evicted. This means: They are stored inside the Redis Cache forever!

If we want to change this behaviour we have to setup our CacheManager to have a default TTL, but more about this later.

So after finishing this part of the implementation your code should look like the one this branch: [https://github.com/eiselems/ultimate-redis-boot/tree/initAndConnect](https://github.com/eiselems/ultimate-redis-boot/tree/initAndConnect)

# 2. Gaining more control
The setup we created just now is really nice. I actually really like it.
It is easy, it does what it should – but it is really general.

It does one thing well: Depending on your parameters the method is guarded by a cache.<br>
In some cases you need more control.

One example we could have here is that we want to cache something in case of exceptions. For me this is quite a common use-case. Sometimes you don’t want to retry something for a minute or so when it didn’t work.

An example here could be fetching some data from an API.
Another one would be logging interaction with your Cache. With @Cacheable it is pretty hard to log something when you are reading from the Cache, since you will never know if a value was returned from Cache our from the method invocation.

Yes, technically you could put a log line inside the method itself and the absence of this message would be an indicator that it was read from the Cache. But this is not quite the same as just saying “Read value X from the Cache”.

We now will build a solution which gives you this kind of control while still being easy to implement.

For the ease of the tutorial, we will create another class called `ControlledCacheService`. There we will now create two methods: One (*getFromCache*)for getting a potential existing entry and another (*populateCache*) to populate the Cache and also return the value.

Let’s have a look at them together:


```java
@Cacheable(cacheNames = "myControlledCache")
public String getFromCache() {
    return null;
}

@CachePut(cacheNames = "myControlledCache")
public String populateCache() {
    return "this is it again!";
}
```

Here we see a few things: `@CachePut` is an annotation which does what it says. The return of a method is getting put into the Cache. In this way it is really similar to `@Cacheable`, the difference is that `@CachePut` is not checking if there is an existing one.

The other thing to see is that `@getFromCache` is returning null. This might be at first confusing but when we write our application logic now it will make sense.

Let’s go to the run method of our Application Class and use this new service.
At first add another Dependency for our `ControlledCacheService`

```java
@Autowired
ControlledCacheService controlledCacheService;
```

Now write a method which we will use for getting values from our ControlledCacheService:

What it needs to do: Call the *getFromCache()* method, if no value was returned call the *populateCache* method.

On top of it: Some fancy logging. The method could look like the following source code


```java
private String getFromControlledCache() {
    String fromCache = controlledCacheService.getFromCache();
    if (fromCache == null) {
        log.info("Oups - Cache was empty. Going to populate it");
        String newValue = controlledCacheService.populateCache();
        log.info("Populated Cache with: {}", newValue);
        return newValue;
    }
    log.info("Returning from Cache: {}", fromCache);
    return fromCache;
}
```

Let’s invoke this method twice from our run() method:
```
log.info("Starting controlled cache: -----------");
String controlledFirst = getFromControlledCache();
log.info("Controlled First: {}", controlledFirst);
String controlledSecond = getFromControlledCache();
log.info("Controlled Second: {}", controlledSecond);
```
And now run the application!

```
Oups - Cache was empty. Going to populate it
Populated Cache with: this is it again!
Controlled First: this is it again!
Returning from Cache: this is it again!
Controlled Second: this is it again!
```

Yeah! It does what it should. The first invocation had a Cache Miss and populated the Cache. The second invocation got the value from the Cache in the first call.
Now you also could see why our ControlledCacheService is returning null. Because the method itself is only invoked when there is nothing in the Cache.
The null is only a marker for a Cache miss, by default Spring Data Redis is not caching null values.

You can find the code after this part of the Guide at: [https://github.com/eiselems/ultimate-redis-boot/tree/ControlledCacheService](https://github.com/eiselems/ultimate-redis-boot/tree/ControlledCacheService).

# 3. Getting rid of our values again
Until now it might have annoyed you already: Once you write something to our Cache, you have to run redis-cli flushall to restore status quo.
Let’s change that! We need some proper eviction.

Eviction is straight forward with the annotations we have, let’s add it first for our first Service: CacheService. There, create another method with the same cacheName, just put a @CacheEvict on top of it

Here is mine:

```java
@CacheEvict(cacheNames = "myCache")
public void forgetAboutThis(){
    log.info("Forgetting everything about this!");
}
```

The same for ControlledCacheService:

```java
@CacheEvict(cacheNames = "myControlledCache")
public void removeFromCache() {
}
```

And the following code inside our run() method in the Application class:

```java
log.info("Clearing all cache entries:");
cacheService.forgetAboutThis();
controlledCacheService.removeFromCache();
```

After this change, the cache will be evicted at the end of our test runs.
From now one (at least after the second run), you should always see a cache miss for the first invocations.

In case you need any guidance on what the code is supposed to look right now: [https://github.com/eiselems/ultimate-redis-boot/tree/addEviction](https://github.com/eiselems/ultimate-redis-boot/tree/addEviction).

Time to have a bit more detailed look into the content of our Redis instance. For this, remove the calls to the evict methods in order to inspect the content of our Redis after the execution.
After we executed our code now once, access **redis-cli**.

Run some commands:

```
redis-cli
127.0.0.1:6379> KEYS *
1) "myControlledCache::SimpleKey []"
2) "myCache::SimpleKey []"
127.0.0.1:6379> TTL "myControlledCache::SimpleKey []"
(integer) -1
127.0.0.1:6379> GET "myControlledCache::SimpleKey []"
"\xac\xed\x00\x05t\x00\x11this is it again!"
```

So what did we do here?

* `KEYS *` we listed all available entries (KEYS) which match the * pattern (* matches against all)
* `TTL “myControlledCache::SimpleKey []”` we checked how long the TTL of our entry is: -1 means infinite
* `GET "myControlledCache::SimpleKey []"` we fetched the value of the specified key.

# Get into Detail
## Cache keys
Until now we just run with the defaults. Let’s assume our methods would be technically more demanding. It could be that we have two arguments, one of the arguments is not relevant for generating the output (e.g. a generated ID we have to pass to another API for tracking).

Let’s change our methods:

CacheService:

```java
@Cacheable(cacheNames = "myCache", key = "'myPrefix_'.concat(#relevant)")
public String cacheThis(String relevant, String unrelevantTrackingId){
    log.info("Returning NOT from cache. Tracking: {}!", unrelevantTrackingId);
    return "this Is it";
}

@CacheEvict(cacheNames = "myCache", key = "'myPrefix_'.concat(#relevant)")
public void forgetAboutThis(String relevant){
    log.info("Forgetting everything about this '{}'!", relevant);
}
```

ControlledCacheService:
```java
@Cacheable(cacheNames = "myControlledCache", key = "'myControlledPrefix_'.concat(#relevant)")
public String getFromCache(String relevant) {
    return null;
}

@CacheEvict(cacheNames = "myControlledCache", key = "'myControlledPrefix_'.concat(#relevant)")
public void removeFromCache(String relevant) {
}

@CachePut(cacheNames = "myControlledCache", key = "'myControlledPrefix_'.concat(#relevant)")
public String populateCache(String relevant, String unrelevantTrackingId) {
    return "this is it again!";
}
```

We just added key attributes to most of our Annotations. What this does is to define the format of our Cache Keys. The annotation values are written in SpEL (in case you need additional help in writing those in the future).

I already gave an example about the mostly used case of combining multiple strings for generating a key. Let’s have a look at one of them in detail: `'myControlledPrefix_'.concat(#relevant)`.
It takes the String `myControlledPrefix_` and adds the relevant attribute of the method execution (that is what the # sign is for) at the end to it.

Cool! But what did we do with these things? Only change the key names?
Not by any means!

### What we now also have: 
Our methods are aware of their inputs. In case we call a method multiple times with different parameters – it will cache them independently. Let’s build an example to showcase this.

Run a quick `flushall` on Redis now and then switch back to your Spring Boot Application Code.
Since we already did most of the work, we have now just to change our Class using the Cache: The `UltimateRedisApplication.class`.

Also, I introduced the usage of UUID to generate our randomStrings, so that we don’t have to bother with thinking about them everywhere.

```java
@Override
public void run(String... args) throws Exception {
    String firstString = cacheService.cacheThis("param1", UUID.randomUUID().toString());
    log.info("First: {}", firstString);
    String secondString = cacheService.cacheThis("param1", UUID.randomUUID().toString());
    log.info("Second: {}", secondString);
    String thirdString = cacheService.cacheThis("AnotherParam", UUID.randomUUID().toString());
    log.info("Third: {}", thirdString);
    String fourthString = cacheService.cacheThis("AnotherParam", UUID.randomUUID().toString());
    log.info("Fourth: {}", fourthString);

    log.info("Starting controlled cache: -----------");
    String controlledFirst = getFromControlledCache("first");
    log.info("Controlled First: {}", controlledFirst);
    String controlledSecond = getFromControlledCache("second");
    log.info("Controlled Second: {}", controlledSecond);

    getFromControlledCache("first");
    getFromControlledCache("second");
    getFromControlledCache("third");
    //log.info("Clearing all cache entries:");
    //cacheService.forgetAboutThis("param1");
    //controlledCacheService.removeFromCache("controlledParam1");
}

private String getFromControlledCache(String param) {
    String fromCache = controlledCacheService.getFromCache(param);
    if (fromCache == null) {
        log.info("Oups - Cache was empty. Going to populate it");
        String newValue = controlledCacheService.populateCache(param, UUID.randomUUID().toString());
        log.info("Populated Cache with: {}", newValue);
        return newValue;
    }
    log.info("Returning from Cache: {}", fromCache);
    return fromCache;
}
```

Most changes here are adding parameters to our calls to the Redis Caches.
So after writing this: What do we expect?

We call our CacheService with: *param1, param1, AnotherParam, AnotherParam*
then ControlledCache with: *first, second, first, second, third*

So for CacheService we should see: *Cache Miss, Cache hit, Cache Miss, Cache hit*
and for ControlledCache: *Cache Miss, Cache Miss, Cache hit, Cache hit, Cache hit*

Let’s run it and verify:

```
Returning NOT from cache. Tracking: 1beaa241-27ba-49fa-9c60-7fab321f6899!
First: this Is it
Second: this Is it
Returning NOT from cache. Tracking: a6f55f7b-0b4a-4e80-a51a-076ad2ed0ab1!
Third: this Is it
Fourth: this Is it
Starting controlled cache: -----------
Oups - Cache was empty. Going to populate it
Populated Cache with: this is it again!
Controlled First: this is it again!
Oups - Cache was empty. Going to populate it
Populated Cache with: this is it again!
Controlled Second: this is it again!
Returning from Cache: this is it again!
Returning from Cache: this is it again!
Oups - Cache was empty. Going to populate it
Populated Cache with: this is it again!
```

I love when things run as expected. 

The code again can be seen on the GitHub repository: The name of the branch is *‘addParametersAndKeys‘* [https://github.com/eiselems/ultimate-redis-boot/tree/addParametersAndKeys](https://github.com/eiselems/ultimate-redis-boot/tree/addParametersAndKeys)

## Cache Key generator example
You might not be the greatest friend of using the SpEL (Spring Expression Language) syntax.

One of the problematic things here is that you can easily make small typos in the Strings of your CacheKeys and then you have a serious bug which might get unnoticed.

Alternatively, you can use static methods to generate your CacheKeys.
Take our `ControlledCacheService` Class as an example. When modified to use a static method for the generation of the key it could look like this:

```java
@Service
public class ControlledCacheService {

    private static final String CONTROLLED_PREFIX = "myControlledPrefix_";

    public static String getCacheKey(String relevant){
        return CONTROLLED_PREFIX + relevant;
    }

    @Cacheable(cacheNames = "myControlledCache", key = "T(com.programmerfriend.ultimateredis.ControlledCacheService).getCacheKey(#relevant)")
    public String getFromCache(String relevant) {
        return null;
    }

    @CachePut(cacheNames = "myControlledCache", key = "T(com.programmerfriend.ultimateredis.ControlledCacheService).getCacheKey(#relevant)")
    public String populateCache(String relevant, String unrelevantTrackingId) {
        return "this is it again!";
    }

    @CacheEvict(cacheNames = "myControlledCache", key = "T(com.programmerfriend.ultimateredis.ControlledCacheService).getCacheKey(#relevant)")
    public void removeFromCache(String relevant) {
    }

}
```

Here we have added the static `getCacheKey` method which is generating the cacheKeys used in the annotations. Since everything here is backed by the compiler – there is a much smaller room for errors while implementing your Cache Keys.

For a better detailed diff between both ways have a look over here: [Link to code on GitHub](https://github.com/eiselems/ultimate-redis-boot/compare/8a1a481c943749abf5a784698b8eea7a3978be8b%E2%80%A6CacheKeyGenerators)

# Define TTLs
This is a huge part of your Cache Toolbox. 
**Time-to-live (TTL)**, is the timespan after which your Cache will be deleting an entry.

If you want to fetch data only once a minute, just guard it with a @Cacheable Annotation and set the TTL to 1 minute.

After the first invocation every further call will hit the cache.
The next request which is at least 1 minute after the first request will again call the real method since the Cache Entry has been removed from the Cache.
Like every serious Caching Implementation, Redis is also capable of setting TTLs per entry.

In this chapter here I want to cover two important things.

1. Setting a default TTL for all Redis Caches within our Spring Boot Application
1. Set specific TTLs per Redis Cache

**Let’s get started and do both of it:**

*One short preface:* Until now, we did not care about the CacheNames inside the Cache-Annotations. For the following steps they are really important. When talking to our CacheManager, the names are used to specify which Cache we are configuring.

## Create a default TTL of 1 minute for all Caches
In order to configure our Cache in more detail we need to start creating a few things. What we will need:
* Properties to store our Redis Configuration
* A few beans to configure our TTLs and the CacheManager

At first we create a class named `CacheConfigurationProperties`.
This is a Spring ConfigurationProperties Container.

```java
@ConfigurationProperties(prefix = "cache")
@Data
public class CacheConfigurationProperties {

    private long timeoutSeconds = 60;
    private int redisPort = 6379;
    private String redisHost = "localhost";
    // Mapping of cacheNames to expira-after-write timeout in seconds
    private Map<String, Long> cacheExpirations = new HashMap<>();
}
```

We create it to keep our Redis Configuration in a single place and make it configurable without touching the code later on.
We have added a timeoutSeconds which should have the default TTL in seconds, a redisPort and redisHost field, which will be used for setting up our RedisConnection and finally a Map which can contain mappings of cacheNames to their TTLs (e.g. ‘myCache’ -> 60).

When this is in place we create another class which is a Spring Configuration.
Here we define a few Beans. Let’s make this quick – here is the code:

```java
@Configuration
@EnableConfigurationProperties(CacheConfigurationProperties.class)
@Slf4j
public class CacheConfig extends CachingConfigurerSupport {

    private static RedisCacheConfiguration createCacheConfiguration(long timeoutInSeconds) {
        return RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofSeconds(timeoutInSeconds));
    }

    @Bean
    public LettuceConnectionFactory redisConnectionFactory(CacheConfigurationProperties properties) {
        log.info("Redis (/Lettuce) configuration enabled. With cache timeout " + properties.getTimeoutSeconds() + " seconds.");

        RedisStandaloneConfiguration redisStandaloneConfiguration = new RedisStandaloneConfiguration();
        redisStandaloneConfiguration.setHostName(properties.getRedisHost());
        redisStandaloneConfiguration.setPort(properties.getRedisPort());
        return new LettuceConnectionFactory(redisStandaloneConfiguration);
    }

    @Bean
    public RedisTemplate<String, String> redisTemplate(RedisConnectionFactory cf) {
        RedisTemplate<String, String> redisTemplate = new RedisTemplate<String, String>();
        redisTemplate.setConnectionFactory(cf);
        return redisTemplate;
    }

    @Bean
    public RedisCacheConfiguration cacheConfiguration(CacheConfigurationProperties properties) {
        return createCacheConfiguration(properties.getTimeoutSeconds());
    }

    @Bean
    public CacheManager cacheManager(RedisConnectionFactory redisConnectionFactory, CacheConfigurationProperties properties) {
        Map<String, RedisCacheConfiguration> cacheConfigurations = new HashMap<>();

        for (Entry<String, Long> cacheNameAndTimeout : properties.getCacheExpirations().entrySet()) {
            cacheConfigurations.put(cacheNameAndTimeout.getKey(), createCacheConfiguration(cacheNameAndTimeout.getValue()));
        }

        return RedisCacheManager
                .builder(redisConnectionFactory)
                .cacheDefaults(cacheConfiguration(properties))
                .withInitialCacheConfigurations(cacheConfigurations).build();
    }
}
```

We put a `@Configuration` on top of the class to make it visible to the Spring Container and also enable the ConfigurationProperties we just created before by referencing them via the @EnableConfigurationProperties annotation.

Now we create four Spring Beans:
* A `LettuceConnectionFactory` (redisConnectionFactory) which uses our properties to set the Hostname and the Port of the Redis Connection.
* A `RedisTemplate` which is overriding the default RedisTemplate in order to leverage the just created RedisConnectionFactory.
* `RedisCacheConfiguration` to provide our Redis default Configuration for places which are not managed by us at the moment
* `CacheManager`: It is the hearth of our Cache Implementation. Here we define our CacheConfigurations. Here we create a Configuration for every cache we specified in the properties. The configuration gets created with the timeout specified in the Map contained in our properties.

**So what did we achieve?**
We created a way on how we can re-configure our TTLs without touching our code.
Let’s try it out, maybe that makes it a bit clearer.

When we have a look at our ControlledCacheService, we can see that all the Cache Annotations there have the cacheName ‘myControlledCache’.
If we go now to the application.propertiesof our Spring Boot Application, we can add for example:

```
cache.timeout=60
cache.cacheExpirations.myControlledCache=180
```

By this we override the properties defined in the CacheConfigurationProperties (see: There we defined the cache prefix *'cache'*).

In our bean definitions we use the `cache.timeout` for defining the default TTL of all our caches.
If there is a mapping in `cache.cacheExpirations`, we override it for the specified Cache.
In our example here, we override the TTL of myControlledCache and set it to 180 (seconds).

Let’s check if this really works.
* For once, make sure that your Application itself is not clearing Redis at the very end.
* Now use `redis-cli` to flush Redis (using `flushall`).
* Start the application using mvn spring-boot:run
* After it finished running, use redis-cli to verify if there are some entries
  * redis-cli KEYS * should give you a few
  * Now check the TTL of one of our keys belonging to the ‘myControlledCache’ Cache
  Run: `TTL "myControlledCache::myControlledPrefix_first")` inside `redis-cli`. It should hopefully give you an Integer between 0 and 180.
  This is the time this entry is still in the Cache. Try running the command again, it should give you a lower number in comparison to the first query.
  (In case you get a -2, you were either too slow or by accident flushed Redis. Try running your Spring Boot Application again and have another look).
  * Now do the same thing for one entry of the ‘myCache’. Run `TTL "myCache::myPrefix_param1"`. It should give you a value between 0 and 60. As you can see the entries of ‘myCache’ live for 60 Seconds and the entries of ‘myControlledCache’ have a TTL of 180 seconds. 

**Awesome!**

# Warning:
One thing I did not mention in this tutorial but I don’t want to leave it out:
**!!! Never ever call a method annotated with @Cacheable or any of the other methods from within the same class!!!**

The reason is that Spring proxies the access to this methods to make the Cache Abstraction work. When you call it within the same class this Proxy mechanic is not kicking in. By this you basically bypass your Cache and make it non-effective. Your cache will never get used from within the same class. I have seen this already more often than I should in Pull requests and even in code running in production.

# Recap:
Let take a step back and see what we did until now:

We learned a lot in this tutorial. We installed the Redis Server including the redis CLI on our machine. Together we created a Spring Boot Application which gates a few of our methods using the Spring Cache Abstraction. In order to achieve this, we used a single `@Cacheable` Annotation but also more granular controls by using also other Cache-Annotations like `@CachePut`. After that we added the `@CacheEvict` annotation to enable our Spring Boot Application to remove existing Cache Entries from our Redis Cache.

After that, we made the Cache Abstraction aware of parameters. We also learned how to create the Cache Keys based on the input parameters of our methods.
At the end we set a default TTL for all our Caches and also created a way to set the TTL per Cache.

After following this Guide along you should be able to create Spring Boot 2 Applications which leverage Spring Data Redis to create really powerful Cache Mechanics.

I hope you enjoyed reading this tutorial and could easily follow along.
The complete code is available at [https://github.com/eiselems/ultimate-redis-boot](https://github.com/eiselems/ultimate-redis-boot).

I would really love to hear back from you about how you liked it. In case you have some questions feel free to reach out to me using [twitter](https://twitter.com/eiselems).

**Happy Caching!**

