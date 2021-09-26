title=Book Review: Practical Cloud-Native Java Development with MicroProfile
date=2021-09-24
type=post
tags=java
status=published
~~~~~~

![Practical Cloud-Native Java Development with MicroProfile cover](/images/posts/practicalcn/cover.png "Practical Cloud-Native Java Development with MicroProfile")

## General information

* Pages: 403
* Published by: Packt
* Release date: Aug 2021

> Disclaimer: I received this book as a collaboration with Packt and one of the authors (Thanks Emily!)

## A book about Microservices for the Java Enterprise-shops

Year after year many enterprise companies are struggling to embrace Cloud Native practices that we tend to denominate as Microservices, however [Microservices is a metapattern](https://microservices.io/patterns/microservices.html) that needs to follow a well defined approach, like:

* (We aim for) reactive systems
* (Hence we need a methodology like) 12 Cloud Native factors
* (Implementing) well-known design patterns
* (Dividing the system by using) Domain Driven Design
* (Implementing microservices via) Microservices chassis and/or service mesh
* (Achieving deployments by) Containers orchestration

Many of these concepts require a considerable amount of context, but some books, tutorials, conferences and YouTube videos tend to focus on specific niche information, making difficult to have a "cold start" in the microservices space if you have been developing regular/monolithic software. For me, **that's the best thing about this book, it provides a holistic view to understand microservices with Java and MicroProfile for "cold starter developers"**.

## About the book

Using a software architect perspective, **MicroProfile could be defined as a set of specifications (APIs) that many microservices chassis implement in order to solve common microservices problems through patterns, lessons learned from well known Java libraries**, and proposals for collaboration between Java Enterprise vendors. 

Subsequently if you think that it sounds a lot like Java EE, that's right, **it's the same spirit but on the microservices space with participation for many vendors**, including vendors from the Java EE space -e.g. Red Hat, IBM, Apache, Payara-.

The main value of this book is **the willingness to go beyond the APIs**, providing four structured sections that have different writing styles, for instance:

1. Section 1: Cloud Native Applications - Written as a didactical resource to learn fundamentals of distributed systems with Cloud Native approach
2. Section 2: MicroProfile Deep Dive - Written as a reference book with code snippets to understand the motivation, functionality and specific details in MicroProfile APIs and the relation between these APIs and common Microservices patterns -e.g. Remote procedure invocation, Health Check APIs, Externalized configuration-
3. Section 3: End-to-End Project Using MicroProfile - Written as a narrative workshop with source code already available, to understand the development and deployment process of Cloud Native applications with MicroProfile
4. Section 4: The standalone specifications - Written as a reference book with code snippets, it describes the development of newer specs that could be included in the future under MicroProfile's umbrella

### First section

This was by far my favorite section. **This section presents a well-balanced overview about Cloud Native practices** like:

* Cloud Native definition
* The role of microservices and the differences with monoliths and FaaS
* Data consistency with event sourcing
* Best practices
* The role of MicroProfile

I enjoyed this section because my current role is to coach or act as a software architect at different companies, hence **this is good material to explain the whole panorama to my coworkers and/or use this book as a quick reference**.

My only concern with this section is about the final chapter, this chapter presents an application called IBM Stock Trader that (as you probably guess) IBM uses to demonstrate these concepts using MicroProfile with OpenLiberty. The chapter by itself presents an application that combines data sources, front/ends, Kubernetes; however the application would be useful only on Section 3 (at least that was my perception). Hence you will be going back to this section once you're executing the workshop.

### Second section

This section divides the MicroProfile APIs in three levels, the division actually makes a lot of sense but was evident to me only during this review:

1. The base APIs to create microservices (JAX-RS, CDI, JSON-P, JSON-B, Rest Client)
2. Enhancing microservices (Config, Fault Tolerance, OpenAPI, JWT)
3. Observing microservices (Health, Metrics, Tracing)

Additionally, **section also describes the need for Docker and Kubernetes and how other common approaches -e.g. Service mesh- overlap with Microservice Chassis functionality**.

Currently I'm a MicroProfile user, hence I knew most of the APIs, however I liked the actual description of the pattern/need that motivated the inclusion of the APIs, and the description could be useful for newcomers, along with the code snippets also available on GitHub.

If you're a Java/Jakarta EE developer you will find the CDI section a little bit superficial, **indeed CDI by itself deserves a whole book/fascicle** but this chapter gives the basics to start the development process.

### Third section

This section switches the writing style to a workshop style. **The first chapter is entirely focused on how to compile the sample microservices**, how to fulfill the technical requirements and which MicroProfile APIs are used on every microservice. 

You must notice that this is not a Java programming workshop, it's a Cloud Native workshop with ready to deploy microservices, hence the step by step guide is about compilation with Maven, Docker containers, scaling with Kubernetes, operators in Openshift, etc.

You could explore and change the source code if you wish, but the section is written in a "descriptive" way assuming the samples existence.

### Fourth section

This section is pretty similar to the second section in the reference book style, hence it also describes the pattern/need that motivated the discussion of the API and code snippets. **The main focus of this section is GraphQL, Reactive Approaches and distributed transactions with LRA**. 


This section will probably change in future editions of the book because at the time of publishing the Cloud Native Container Foundation revealed that some initiatives about observability will be integrated in the OpenTelemetry project and MicroProfile it's discussing their future approach.

## Things that could be improved

As any review this is the most difficult section to write, but I think that a second edition should:

* Extend the CDI section due its foundational status
* Switch the order of the Stock Tracer presentation
* Extend the data consistency discussión -e.g. CQRS, Event Sourcing-, hopefully with advances from LRA

The last item is mostly a wish since I'm always in the need for better ways to integrate this common practices with buses like Kafka or Camel using MicroProfile. I know that some implementations -e.g. Helidon, Quarkus- already have extensions for Kafka or Camel, but **the data consistency is an entire discussion about patterns, tools and best practices**.

## Who should read this book?

* Java developers with strong SE foundations and familiarity with the enterprise space (Spring/Java EE)