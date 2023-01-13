title=Creating testable Jakarta EE 10 projects with Java 17 and MySQL (A step-by-step guide)
date=2023-01-14
type=post
tags=java
status=draft
~~~~~~

In this "Giga" tutorial I'll try to consolidate some introductory knowledge and the steps needed to create a testable (Integration testing) project on Jakarta EE 10 and Java 17.

The tutorial aims to be portable between traditional application servers, hence when created (2023-01-13) I selected three of the four [implementations compatible with Jakarta EE 10](https://jakarta.ee/compatibility/download/), being Glassfish 7, Payara 6, and Wildfly 27.

For the record, I left out [FUJITSU Software Enterprise Application Platform](https://www.fujitsu.com/jp/products/software/middleware/business-middleware/middleware/applatform/) on purpose, basically because my Japanese is mostly Naruto's catchphrases.

Through the text, you'll find some links to go deeper into each of the concepts, and many "down-to-earth" explanations about each of the concepts, hence it could be tiresome for more experienced people but useful for beginners. You could safely jump "down-to-earth" explanations if you want to.

My main intention is to provide a complete tutorial for beginners and people on-boarding enterprise Java.

This tutorial is divided into the following sections:

0. What is Jakarta EE anyway
1. Bootstrapping a Jakarta EE 10 Project with Java 17
2. A basic JAX-RS API with CDI and Data Persistence capabilities
3. Integration tests with Arquillian and JUnit 5 over Glassfish/Payara
4. Integration tests with Arquillian and JUnit 5 over Wildfly
5. Configuring MySQL data source with Payara/Glassfish descriptors
6. Configuring MySQL data source with Wildfly descriptors
7. Bootstrapping real databases with Testcontainers and Docker
8. Wrap up and final GitHub repository

## What is Jakarta EE anyway

From [Jakarta EE's website](https://jakarta.ee/about/jakarta-ee/) you could extract the following definition:

> Jakarta EE gives developers a comprehensive set of vendor neutral, open specifications that are used for developing modern, cloud native Java applications from the ground up. With Jakarta EE, technology developers and consumers can be confident they have the best technologies for developing cloud native, mission-critical applications. And they can build on decades of Java developer expertise to move existing workloads to the cloud.

### What does this mean for the developers? (Down to earth)

One of the strongest points of being a Java developer is **the ecosystem**. In principle, you could choose among different providers for JVM, frameworks, libraries, and runtimes. This has been the situation since Sun Microsystems era and you will find different frameworks for different needs, for example, if we want to create a REST API with Java the first selection should be among:

* Microframeworks that provide an imperative programming model and HTTP communications like [SparkJava](https://sparkjava.com/) or [Javalin](https://javalin.io/)
* Opinionated end-to-end frameworks with their own mindset and way of doing things like [Armeria](https://armeria.dev/) or [Akka](https://akka.io/) 
* Generalistic end-to-end frameworks based on declarative programming (annotations), like [Spring Boot](https://spring.io/projects/spring-boot) or [Dropwizard](https://www.dropwizard.io/en/latest/)

With this in mind, a regular Java developer can't know every particular aspect of every framework, hence in many situations your knowledge about one solution is not portable at all to other solutions despite **both solutions being Java**.

What to do about it? In 1998 Sun Microsystems created the Java Community Process, a [standards organization](https://en.wikipedia.org/wiki/Standards_organization) aiming to provide a common set of technical specifications for Java Core (J2SE), Java Micro (J2ME) and Java Enterprise (J2EE). Fast forwarding to present times J2EE became Java EE, and some years later the [Java EE process was donated to the Eclipse [Foundation](https://www.infoq.com/news/2017/09/JavaEEtoEclipse/), where Jakarta EE was born. Within Eclipse, software providers (communities or companies) could take (or propose) a specification, aiming for technical common grounds to define a "Java enterprise way" of doing things.

A specification "product" is mostly (but not exclusively) four things, 1. A sub-project in charge of specification, basically a community composed of interested parties, 2. The specification definition (documentation about it), 3. A set of Java APIs and 4. A set of compatibility tests to validate eventual implementations (TCK).

## How Jakarta EE looks in the real life (Down to earth)

Let's take one of the most popular Jakarta EE specifications, the specification for Java object persistence -i.e. **Jakarta Persistence**-. 

The textual definition of it is:

> Jakarta Persistence defines a standard for management of persistence and object/relational mapping in Java® environments.

As you probably are guessing, it has (at least) the four elements described previously, being:

1. [A community steering the specification](https://jakarta.ee/specifications/persistence/3.1/)
2. [The specification definition](https://jakarta.ee/specifications/persistence/3.1/jakarta-persistence-spec-3.1.html)
3. [A set of Java APIs](https://github.com/jakartaee/persistence/tree/master/api)
4. [A TCK](https://download.eclipse.org/jakartaee/persistence/3.1/jakarta-persistence-tck-3.1.0.zip)

Later or during the specification creation, communities and companies create Java libraries and/or products compatible with this specification, at this time Jakarta Persistence 3.1 has two implementations:

1. [EclipseLink (Eclipse)](https://www.eclipse.org/eclipselink/releases/4.0.php)
2. [Hibernate (Red Hat)](https://hibernate.org/orm/releases/6.1/)

In practical terms, this means that EclipseLink and Hibernate as libraries provide the source code to satisfy the Jakarta Persistence objective, being tested against the TCK, and having a predictable behavior where your knowledge about Jakarta Persistence is portable. If you decide to stay in the specification, your code will be portable among implementations.

At the same time, each project provides extra capabilities like being compatible with some particular cache -e.g. [Infinispan and Hibernate](https://infinispan.org/docs/stable/titles/hibernate/hibernate.html)- or having extra features for some particular databases -e.g. [EclipseLink and Oracle](https://www.eclipse.org/eclipselink/documentation/2.5/solutions/oracledb.htm)-. If you decide to use the extra capabilities, your code probably won't be portable among implementations but it still will have the **Enterprise way** of doing things.

## Collections of specifications and certified runtimes

Some Jakarta specifications are more popular than others, and **most importantly** not every Java community or company will adopt every especification. 

For example both [Spring Boot](https://spring.io/projects/spring-data-jpa) and [Micronaut](https://micronaut-projects.github.io/micronaut-data/latest/guide/#hibernate) offer abstraction data layers over JPA, but each has its own way to define REST endpoints ([Spring](https://spring.io/guides/gs/rest-service/), [Micronaut](https://docs.micronaut.io/2.0.0.M2/api/io/micronaut/http/annotation/Controller.html)).

Still, if a given company or community decides to fully embrace Jakarta EE, it can be certified against [Jakarta EE profiles](https://jakarta.ee/release/10/):

* Jakarta EE Core: Offering a minimalistic set of specifications for REST services creation
* Jakarta EE Web: Offering a set of specifications for creating Web applications
* Jakarta EE Full: Offering a complete set of specifications for products that need to offer a robust set of feature for any kind of Java Enterprise applications

Again, a given product could target the minimum to comply with Jakarta EE Core, but still offer a lot of extras with its own mindset and not necesarly compatible with Jakarta EE Full, like Quarkus [which is planing to support Jakarta EE 10](https://es.quarkus.io/blog/our-bumpy-road-to-jakarta-ee-10/)).

## Which one is better?

Not my call to do since it depends on your needs. Still, if you want an oppinion.

I tend to prefer [Payara](https://www.payara.fish/) if I need an standalone server, mostly because I have many years of experience in Glassfish. Also if I need to distribute a simple application on a fatjar I tend to use Payara Micro or [Apache TomEE](https://tomee.apache.org/).

If I need a microservice architecture, I'll probably be using [Quarkus](https://quarkus.io/) or [Helidon](https://helidon.io/).

If I need a lambda function, [Quarkus](https://quarkus.io/) it is.

