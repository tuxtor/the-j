title=Book Review: Enterprise Java Microservices by Ken Finnigan
date=2018-12-19
type=post
tags=java
status=published
~~~~~~

![Enterprise Java Microservices cover](/images/posts/ejmicro/cover.png "Enterprise Java Microservices")

## General information

* Pages: 245
* Published by: Manning
* Release date: nov 2018

## Some context on learning Microservices

Let's clarify one thing, switching from Monoliths to Microservices is not like switching from traditional JavaEE to Spring (and viceversa), **is more like learning to develop software again** because you have to learn:

* New architectural patterns
* How to work with distributed transactions
* How to guarantee consistency in distributed data (or not)
* New plumbing/management tools like Docker, Kubernets, Pipelines
* New frameworks and/or old frameworks with new Cloud Native capabilities

Despite really good publications like the [12 factors for web native applications](https://12factor.net/). **From my perspective the real challenge on learning Microservices is the lack of a central documentation/tutorial/from 0 to wow guide.**

In the old days, if you wanted to learn enterprise software development on Java, you simply took the Java EE tutorial from 0 to 100, maybe a second tutorial like [Ticket Monster](https://developers.redhat.com/ticket-monster/), a couple of reference books and that's it. However, learning Microservices is more like:

* Learning new cloud native capabilities of old frameworks in documentations that take for granted your knowledge of previous versions of the framework
* Or learning new frameworks with words like reactive, functional, non-blocking, bazinga
* Learning new design patterns without knowing the real motivation of each pattern
* Surfing in a lot of reddit and StackOverflow discussions on not-so clear explanations
* Learning Docker and Kubernets because every body is doing it
* Hitting end roads because you are accustomed to things like JNDI, JTA, Stateful sessions

## About the book

Do you see the problem? The lack of a cohesive guide that explains who, how and why you need the zillion of new tools makes the path of learning Microservices an uphill battle, and that's where **Enterprise Java Microservices** shines.

Enterprise Java Microservices is one of the **first attempts to create a cohesive guide with special focus on Java EE developers and MicroProfile**. The book is divided in two main sections, the first one focused on Microservice basics (my favorite) and the second one focused on Microservices implementations with specific libraries (being a little bit biased for Red Hat Solutions).

### First section

**For those that already have some Enterprise Java knowledge but don't have too much idea about the new challenges in the Microservice world this will be the most useful section**, with your actual knowledge you should be able to understand:

* The main differences between monoliths and microservices architectural styles and patterns, this is by far the most important section for me and gave me a couple of new ideas debunking some misconceptions that I had
* Just Enough and Micro application servers/frameworks
* New jargon on the cloud native world (yup you have to learn a lot of new acronyms)
* General knowledge on testing Microservices
* Why do you need new tools like service discovery, service registry, gateways, etc.
* Principles of reactive applications

This section also includes a brief introduction to API/Rest Web Services creation with Java EE and Spring, however I'm not sure about the feeling of this section for a newcomer.


### Second section

Once you took the basis from the first section (or from bad implementations and end roads in the real life like me), this section will cover three of the most complex and important topics in Microservices, being:

1. Service discovery and load balancing
2. Fault tolerance (circuit breakers, bulkheads, etc.)
3. Strategies for management and monitoring microservices

**The chapters of the second section are structured in a way that makes easier to understand why do you need the "topic" that you are about to learn**, however and despite being early focused on MicroProfile, it will use specific libraries like Hystrix, Ribbon and Feing (yes, like in Spring Boot) for the implementation of these patterns, adding also some specific integrations with Thorntail.

Later on, the book evolves over a sample application, covering topics like security, architectures with Docker/Kubernets and data streams processing, where as I said a particular bias is present, implementing the solutions by using Minishift, Keycloack and other Red Hat specifics.

To clarify, **I don't think that this bias is bad, considering that there are (as I said) a zillion of alternatives for [those factors not covered by Java](https://www.eclipsecon.org/europe2018/sessions/build-12-factor-microservice-using-microprofile)**, I think it was the right decision.

## Things that could be better

As any review this is the most difficult section to write, but I think that a second edition should include:

* MicroProfile fault tolerance
* MicroProfile type safe clients

Since Ken is one of the guys behind MicroProfile implementation in Red Hat, I'm guessing that the main motivation for not including it is simple, MicroProfile is evolving so fast that these standards were presented after book printing.

People looking for data consistency patterns (CQRS, Event Sourcing, eventual consistency, etc.) could find the streaming processing section a little smaller than it should be.

## Who should read this book?

* Java developers with strong foundations, or experience in Spring or Java EE

Yes, despite their coverage of basic APIs, I think that you need foundations like those covered in OCP certification, otherwise you will be confused in the implementation of annotations, callbacks, declarative and imperative code.