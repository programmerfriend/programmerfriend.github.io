---
layout: post
title: "Random Number Generation with Java"
bigimg: /img/content/java-random-numbers_title.jpg
share-img: https://programmerfriend.com/img/content/java-random-numbers_title.jpg
gh-repo: eiselems/java-random-numbers
gh-badge: [star, fork, follow]
tags: [java, tutorial]
---
Random Numbers are really important. Without them there would be no Internet how we know it!

This article will explain in detail how generating Random Numbers in Java works.
It will introduce different technics to create Random Numbers and also cover different scenarios with ready-to-use code. 

Let's first start with the basics.

## Generating Random Numbers with Java:

Java provides at least fours ways of properly creating random numbers.

### 1. Using Math.random Method
The most basic way of generating Random Numbers in Java is to use the [`Math.random()`](https://docs.oracle.com/javase/8/docs/api/java/lang/Math.html#random--) method.

It doesn't take any parameter and simply returns a number which is greater than or equal 0.0 and less than 1.0. In comparison to other methods, `Math.random()` only returns Double values.

Let's have a quick look at the example:

```java
public class MainMathRandom {

    public static void main(String[] args) {
        //Generate random numbers between 0.0 (inclusive) and 1.0 (exclusive)
        double firstRandomValue = Math.random();
        double secondRandomValue = Math.random();

        //Print the generated random values
        System.out.println("First randomValue: " + firstRandomValue);
        System.out.println("Second randomValue: " + secondRandomValue);
    }
}
```

Example output:
```bash
First randomValue: 0.18096838743157928
Second randomValue: 0.9664240431908591
```
<br>
### 2. Using java.util.Random Class

The [`java.util.Random`](https://docs.oracle.com/javase/8/docs/api/java/util/Random.html) is really handy. It provides methods such as `nextInt()`, `nextDouble()`, `nextLong()` and `nextFloat()` to generate random values of different types.

When you invoke one of these methods, you will get a Number between 0 and the given parameter (the value given as the parameter itself is excluded).

In order to use it, you have to first create an instance of the class. Have a look at the following example code:

```java
import java.util.Random;

public class MainRandom {

    public static void main(String[] args) {
        //Initialize the random object
        Random random = new Random();

        //Generate numbers between 0 and 100
        int firstRandomValue = random.nextInt(101);
        int secondRandomValue = random.nextInt(101);

        //Print the generated random values
        System.out.println("First int: " + firstRandomValue);
        System.out.println("Second int: " + secondRandomValue);

        //Generate double random values (values are between 0 (inclusive) and 1.0 (exclusive))
        double firstRandomDouble = random.nextDouble();
        double secondRandomDouble = random.nextDouble();

        //Print the generated random values
        System.out.println("First double: " + firstRandomDouble);
        System.out.println("Second double: " + secondRandomDouble);
    }
}
```

Example output:
```shell
First int: 60
Second int: 68
First double: 0.3624141957261017
Second double: 0.42704069834866554
```
<br>
### 3. Using java.util.concurrent.ThreadLocalRandom Class

This class was added in Java 1.7, so hopefully you can use it. 

[`ThreadLocalRandom`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ThreadLocalRandom.html) is similar to the previous approach and defines methods such as `nextInt()` or `nextDouble()`. In fact, it is just a small change to the previously used `Random`. See for yourself:

```java
import java.util.concurrent.ThreadLocalRandom;

public class MainThreadLocalRandom {

    public static void main(String[] args) {
        //Initialize the random object
        ThreadLocalRandom current = ThreadLocalRandom.current();

        //Generate numbers between 0 and 100
        int firstRandomValue = current.nextInt(101);
        int secondRandomValue = current.nextInt(101);

        //Print the generated random values
        System.out.println("First int: " + firstRandomValue);
        System.out.println("Second int: " + secondRandomValue);

        //Generate double random values (values are between 0 (inclusive) and 1.0 (exclusive))
        double firstRandomDouble = current.nextDouble();
        double secondRandomDouble = current.nextDouble();

        //Print the generated random values
        System.out.println("First double: " + firstRandomDouble);
        System.out.println("Second double: " + secondRandomDouble);
    }
}
```

Example output:
```bash
First int: 11
Second int: 3
First double: 0.3104717654005008
Second double: 0.7118640850137595
```
<br>
### 4. Using java.security.SecureRandom

The previous solutions are using pseudo-random numbers. This one here is a `cryptographically strong random number generator` see the JavaDocs of [SecureRandom](https://docs.oracle.com/javase/8/docs/api/java/security/SecureRandom.html).

The implementation only differs slightly from the ones before. Frankly speaking, it is a drop-in replacement for `Random`:

```java
import java.security.SecureRandom;

public class MainSecureRandom {

    public static void main(String[] args) {
        //Initialize the random object
        SecureRandom random = new SecureRandom();

        //Generate numbers between 0 and 100
        int firstRandomValue = random.nextInt(101);
        int secondRandomValue = random.nextInt(101);

        //Print the generated random values
        System.out.println("First int: " + firstRandomValue);
        System.out.println("Second int: " + secondRandomValue);

        //Generate double random values (values are between 0 (inclusive) and 1.0 (exclusive))
        double firstRandomDouble = random.nextDouble();
        double secondRandomDouble = random.nextDouble();

        //Print the generated random values
        System.out.println("First double: " + firstRandomDouble);
        System.out.println("Second double: " + secondRandomDouble);
    }
}
```

**Word of Warning:**

You might be inclined to always use `SecureRandom` instead of the other methods, because who doesn't want security?

Using `SecureRandom` has one big downside. `SecureRandom` can be blocking if the system does not have enough entropy to guarantee the randomness.

Please keep this in mind.

## Scenarios:

Now that we covered the basics, you should be able to generate all kind of random numbers you need.

As a reference, here are some common scenarios for generating random numbers. For these examples we will use `java.util.Random`, but using the other approaches should be quite similar.

### Integer between 0 and 9 (0 <= x < 10 )
```java
//Generate numbers between 0 and 9 (0 <= X < 10)
int zeroToTenExclusive = random.nextInt(10);
```

### Integer between 0 and 10 (0 <= X <= 10)
```java
//Generate numbers between 0 and 10 (0 <= X <= 10)
int zeroToTenInclusive = random.nextInt(11);
```

### Integer between 0 and 10 (0 < X < 10)
```java
//Generate numbers between 0 (exclusive) and 10 (exclusive)
int zeroToTenBothExclusive = random.nextInt(9) + 1;
```

### Random Integer Between Range not starting with zero

**Hint:** You should re-use the Random object here and not create a new one on each invocation. I didn't pull it out to leave the first example intact.

```java
public static void main(String[] args) {
    //Random Integer between Range not starting from 0
    int randomIntegerRange = getRandomIntegerWithinRange(10, 20);
    System.out.println("randomIntegerRange: " + randomIntegerRange);
}

private static int getRandomIntegerWithinRange(int min, int max) {
    int spread = max - min;
    return new Random().nextInt(spread + 1) + min;
}
```

<br>

# Recap

After working on this article we are able to generate random numbers for our Java Applications.

We had a look at including and excluding the bounds and also at creating random numbers not starting from zero.

With this knowledge, you should be able to cover all your needs when it comes to random numbers.

All the code is also available on [Github](https://github.com/eiselems/java-random-numbers/)

<br><br>
I hope you liked the article and could learn something from it!

Feel free to reach out on [Twitter](https://twitter.com/eiselems) in case you want to discuss or just say `Hi!`.