title=Book Review: Kotlin for Java Developers
date=2025-12-11
type=post
tags=java
status=published
~~~~~~

![Kotlin for Java Developers](/images/posts/kotlin/kotlin-book-cover.png "Kotlin for Java Developers")

## General information

* Pages: 414
* Published by: Packt
* Release date: October 2025

> Disclaimer: I received this book as part of a collaboration with Packt

## TL;DR

Essentially, this is a book that uses a "problem-reasoning-solution" approach to present the building blocks that make Kotlin interesting and different from Java. Hence, it isn't:

* A Kotlin reference book (i.e., it does not provide deep technical documentation)
* A book for learning how to program from scratch

**In my opinion, it delivers what it promises.**

## About the book and how I read it

I work with both Java and Kotlin professionally. However, as a technical trainer I'm always looking for educational resources that can boost students' knowledge, either as a main reference or as a complementary resource. I think this book fits the latter category.

Right from the cover, the book states its value proposition:

> Confidently transition from Java to Kotlin through hands-on examples and idiomatic Kotlin practices

I believe it achieves that, although at least in the first two chapters the writing style can make the book somewhat hard to read.

## A rocket that takes time to launch but can reach Mars

The book is divided into four sections:

1. Getting started with Kotlin
2. Object-Oriented Programming
3. Functional Programming
4. Coroutines, Testing and DSLs

My least favorite section was the first, especially the first two chapters. The first chapter tries to give an overview of Kotlin versus Java, but it is too superficial and perhaps even unnecessary. I imagine the goal of this chapter is to spark interest in Kotlin, but it also anticipates that everything will be covered in more detail later. Personally, I almost skipped this chapter because I knew I would see the topics in more depth later. I suppose that's a matter of taste.

Then, the second chapter sketches out Maven and Gradle without going in depth, which felt redundant since the book is targeted at Java developers. I expected more detail in this section about which plugins are used in the build process, how they interact with Maven lifecycles, and other specific topics. But the book delegates this responsibility to the IDE wizard and that's it.

From chapter three onward something magical happens. The book finally launches and its value proposition starts to materialize. Starting in chapter three the writing style changes and consistently presents concept by concept. Almost every chapter is structured like this:

* A common problem is discussed, often respectfully from a Java perspective
* The Kotlin design decision is presented and how it aims to improve the problem
* A concise, self-contained Kotlin snippet explains the programming concept

This last part is what gives the book its value. Studying a programming language — especially when you already know how to program — is a different process than learning to program for the first time. This book recognizes that and discusses Kotlin's value propositions in technical terms, presenting self-contained snippets that readers can try in their IDE or download from the book's official repository.

If I were to use a rocket analogy, imagine that the following chapters are like Apollo 11 in full ascent from Cape Canaveral.

Part I
* Null and non-nullable types
* Extension Functions and the apply function

Part II
* Object-Oriented programming basics
* Generics and variance
* Data and sealed classes

Because this is not a reference book or official documentation, up to this point the book presents each concept well without diving into corner cases — which is fine. With practice, the book can be completed in about a week and provides a solid foundation for moving to the next level, whether that's Android development or Kotlin backend programming.

From Part III there is a noticeable shift: we leave the Java-centric atmosphere and enter idiomatic Kotlin territory. Java-only developers will likely notice this change, as we move into structures that are often too abstract to have direct equivalents in Java, including:

Part III - All this in the "Kotlin way"
* Basics of functional programming 
* Lambdas
* Collections and sequences

Part IV
* Coroutines
* Synchronous and asynchronous programming

Finally, once we're in orbit the book presents two topics that are useful for day-to-day development but are not strictly part of the language:

* Kotlin testing
* Domain-specific languages (DSLs)

## Things that could be improved

As with any review, this is the most difficult section to write. Besides the first two chapters, I noticed a few things that could cause confusion:

* The null safety chapter omits any mention of Java's `Optional`
* The coroutines section briefly mentions Virtual Threads but then presents Loom as a separate effort and likens it to Quasar (a library ecosystem). In reality, Virtual Threads are part of Project Loom
* The book inconsistently presents different JDK recommendations across chapters; sometimes it suggests Corretto while other times it simply suggests OpenJDK
* Also on the JVM side, most of the time it suggests Java 17. I imagine this was related to the time of writing. I can say that all samples worked just fine on Java 25 (the latest LTS at the time of writing), so you should be fine using that or Java 21.

## Who should read this book?

* Java developers exploring the Kotlin ecosystem, those interested in Android development, or developers considering switching to Kotlin as their primary language
