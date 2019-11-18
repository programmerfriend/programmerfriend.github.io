---
layout: post
title: "Kotlin Features that Java Developers love"
bigimg: /img/content/kotlin-java_title.jpg
share-img: https://programmerfriend.com/img/content/kotlin-java_title.jpg
description: "Kotlin Features that Java Developers love"
tags: [spring-boot, kotlin]
---

Hey folks,

over the last weeks, we had a discussion at work whether or not we should make Kotlin the default for our future Spring Boot application development.

For now, we don't have a decision but I think there are a lot of good arguments on both sides.

Java is a battle-tested, multiple-decade old programming language. Kotlin is the new kid on the block.

Let's have a detailed look into what Kotlin really has to offer in comparison to Java.
The following list is not by any means complete - these are just the things I found most important so far.

## Kotlin Language Features

One of the most important factors for migrating to Kotlin is the **Java Interoperability**. In most cases, calling a Kotlin code from Java code (and vice-versa) works flawlessly. That's why you can even think about using Kotlin for writing applications in one of your favorite frameworks.

Let's have a look at all the other things that Kotlin has to offer.

### Null-Safety

Even if you are just a starter, you for sure have encountered on of these dreaded **Nullpointer Exceptions**.

Nullpointer Exceptions are so dangerous because they occur during runtime and crash your program.
Tony Hoare, who introduced the *NULL references* in ALGOL W even titled them as his **"billion-dollar mistake"**.

What if I tell you that Kotlin is by design avoiding this issue?

In Kotlin you have to distinguish between references that might and references that are not allowed to contain **NULL** references. Nullpointer Exceptions happen when you invoke an operation on a Null Reference. With Kotlin's Null-Safety, these invocations are already caught by the compiler.

### High-Order-Functions

A higher-order function is a function that takes functions as parameters or returns a function.

There are use-cases where this comes in really handy. One use-case which comes to my mind is the fold function which allows reducing collections to a single parameter by re-applying the given function again and again.

### Smart Casts

The Kotlin Compiler tracks explicit casts and `is`-checks. Based on this information it applies (safe) casts automatically.

Example:
```
fun example(x: Any) {
    if (x is String) {
        print(x.length) //here no cast is necessary
    }
}
```

### String Templates

After using them for a while, you really start to miss them in Java.
I am talking about String Templates. String Templates make it really easy to build Strings out of variable values.

Example:
```
val name = "Programmerfriend"
println("$name.length is ${$name.length}") //prints "Programmerfriend.length is 16
```
<br>
### Extension Functions

Were there ever situations in which you wished that you just could extend a Framework class?
Did you ever want to add a specific method just useful for you to an object provided by a Library?

*Wait no further:* With Kotlin this is possible.

Clarification: Technically this is not 100% correct, but it feels like the described scenario. Extensions are callable by using a dot notation just like any method.

Modified Example from the Kotlin documentation:
```
fun <T> MutableList<T>.swap(index1: Int, index2: Int) {
    val tmp = this[index1] // 'this' corresponds to the list
    this[index1] = this[index2]
    this[index2] = tmp
}

...
Usage:

val list = mutableListOf(1, 2, 3, 4)
list.swap(0, 2) // 'this' inside 'swap()' will hold the value of 'list'
println(list) // prints "[3, 2, 1, 4]"
```

### Data Classes
Tired of writing getters and setters for your DTOs and POJOs?

Kotlin got your back with *data classes*:

Example:

```
data class Person(val firstName: String, val lastName: String, val age: Int)
```

From this definition, the compiler generates:
* `equals()/hashCode()`
* `toString()` using the following syntax `Person(firstName=John,lastName=Doe, age=42)`
* `componentN functions` - needed for Destructuring Declarations (further down in this post)
* `copy()` which allows basically cloning an existing object and modifying specific attributes. This is especially nice to have because of the immutability.
<br>

### Destructuring Declarations

So what are those *componentN functions*?

They are in fact named after their names. The data class definitions creates for each field a component-method e.g. `component1()` and ``component2()`.

This convention allows interesting things - it is the foundation for Destructuring Declarations.

Example with the data class above:
```
val person = Person("John", "Doe", 42)
val (firstName, lastName, age) = person 
println(firstName) //prints John
```
<br>
### Separate Interfaces for read-only and mutable collections

Kotlin offers two kind of interfaces for its collections: Read-only and mutable.

Read-only allows only reading but not modifying the Collection. This is not real immutability since we can still modify the data contained in the collection - but not the collection itself.

Mutable lists also allow to modify the collection (e.g. adding/removing elements).
For more details and examples, please refer to the [excellent documentation](https://kotlinlang.org/docs/reference/collections-overview.html).

### Coroutines

Truth be told, for now, I have not written any Coroutine myself.
But according to the documentation, Coroutines are light-weight threads.

They are lightweight in a sense, that not every Coroutine will create a new native thread.
They run on a set of shared threads.

Due to this concept, creating coroutines is really cheap and scales really well.
Suspending functions can be suspended and their worker thread will pick up another task to execute while the method is suspended.

The syntax of all this is really nice to look at. In fact, you could almost miss that you are looking at asynchronous code.

A good resource for getting started is [https://kotlinlang.org/docs/reference/coroutines-overview.html](https://kotlinlang.org/docs/reference/coroutines-overview.html).

### Named and default parameters
A Kotlin feature that really grew on me is the  *named parameters*-Feature.
At first, this might not seem to be a valuable language feature. But maybe you were already dealing with a method call that took 3 String values.
With Kotlin you can call a method and specify which parameter you want to pass at which position.

I think I made it more complicated than it is.

Let's have a look at an example, following syntax is identical.

```
val person = Person("John", "Doe", 42)
val alternatePerson = Person(age = 42, firstName = "John", lastName = "Doe")
println(person)
println(alternatePerson)
```

Named parameters definitely help you tackle bugs by mixing up parameters of the same type.
They also add robustness to refactorings that change the order of parameters.

*Default parameters* add to the overall picture.
If we would modify the Person class to have some default parameters, we could omit them in the constructor call.

```
data class Person(val firstName: String = "John", val lastName: String, val age: Int = 42)
...
Usage:
val person = Person("John", "Doe", 42)
val alternatePerson1 = Person("John", "Doe") // we omitted the last parameter, the first is mandatory
val alternatePerson2 = Person(lastName = "Doe")

println(person) // prints Person(firstName=John,lastName=Doe, age=42)
println(alternatePerson1) // prints Person(firstName=John,lastName=Doe, age=42)
println(alternatePerson2) // prints Person(firstName=John,lastName=Doe, age=42)
```
<br>
### Some missing "Features" in Kotlin

The designers of Kotlin have also removed some language features we know from Java.
One of the examples is the **Checked Exceptions**-Feature.

The reasoning behind this is that a lot of **Checked Exceptions** can never really occur - still, you have to handle them.
This pollutes your code and forces you to ignore them, which is not a good thing.

### Things we did not talk about here

This article is really technical, thus we didn't have a look at non-technical considerations for switching over to Kotlin.

The following list should give you some things to consider before you take the leap and replace Java in your projects with Kotlin:
* **Talent pool**: In 2019 Java is still the main language of the JVM, 2020 will not change that.<br>Finding good, experienced Java Developers could be much easier than finding their Kotlin counterparts *(Disclaimer: Might not be the truth for Android Development)*.
* **Temporary efficieny**: Even your top developers might struggle a bit when switching languages, their development speed might take a temporary hit. In the case of Kotlin, it might not be that bad. Since both languages run on the JVM, they use the same tools and Kotlin is really easy to read and understand for Java  Developers.
* **"Why even bother?"**: Yeah Java has its own quirks, but Kotlin probably too. If you don't have any pain, then probably just don't switch.

## Recap

We learned a lot about some language features that Kotlin has over Java.
If you are still interested, I would really advise you to give Kotlin a try.

A few last words: Often I hear that Kotlin is making your code shorter but in effect making it harder to understand.
In fact, you can write Kotlin code which looks really similar to Java code.

My personal opinion is that you should not overdo it and take the optimizations in moderation. There is no benefit in having a one-liner that nobody understands.
Switching to Kotlin might be beneficial on `null-safety` alone.