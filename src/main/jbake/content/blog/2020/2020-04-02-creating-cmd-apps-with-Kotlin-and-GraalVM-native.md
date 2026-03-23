title=Notes on creating command line applications with GraalVM and Kotlin
date=2020-04-02
type=post
tags=java
status=draft
~~~~~~

In this tutorial I will demonstrate how to create a small CLI application using Kotlin, GraalVM Native, IntelliJ Idea and PicoCLI. The final result should be a **native executable** that runs on Mac and Linux without any JVM installed besides fast startup times (as expected by any CLI utility).

This tutorial is heavily based on other tutorials that could be a good starting point reference, for instance:


## Why GraalVM native

GraalVM Native Image generation is one of the hot features that everybody is talking about in the Java world.

The rationale behind it is very simple, **the possibility of obtaining native (OS dependant) and self contained executable binaries** from Java programs, granting fast startup times and less memory consumption.

This situation is generally advised in environments like:

* CLI applications
* Short lived applications (serverless)
* Microservices swarms

Besides native nature, GraalVM is a whole project that allows to mix many programming languages with backends for JVM Bytecode, LLVM and basically any programing language that could be implemented as an AST.

## General overview

However as any other breakthrough technology 


## Why Kotlin?

Because YOLO

##