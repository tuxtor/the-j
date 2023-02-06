title=Creating testable Jakarta EE 10 projects with Java 17 and MySQL (A step-by-step guide)
date=2023-01-14
type=post
tags=java
status=draft
~~~~~~

In this "Giga" tutorial I'll try to consolidate some introductory knowledge and the **steps needed to create a testable (Integration testing) project on Jakarta EE 10 and Java 17**.

**The tutorial aims to be portable between traditional application servers**, hence when created (2023-01-13) I selected three of the four [implementations compatible with Jakarta EE 10](https://jakarta.ee/compatibility/download/), being Glassfish 7, Payara 6, and Wildfly 27.

For the record, I left out [FUJITSU Software Enterprise Application Platform](https://www.fujitsu.com/jp/products/software/middleware/business-middleware/middleware/applatform/) on purpose, my Japanese is mostly Naruto's catchphrases.

**Through the text, you'll find some links and many "down-to-earth" explanations about each of the concepts**, hence it could be tiresome for more experienced people but useful for beginners. You could safely jump "down-to-earth" explanations if you want to.

My main intention is to provide **a complete tutorial for beginners** and people on-boarding enterprise Java.

This tutorial is divided into the following sections:

0. What is Jakarta EE anyway
1. Bootstrapping new Jakarta EE 10 projects with Eclipse Starter for Jakarta EE
2. Configuring applications servers and Java IDEs
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

### What does this mean for the developers?

One of the strongest points of being a Java developer is **the ecosystem**. In principle, you could choose among different providers for JVM, frameworks, libraries, and runtimes. This has been the situation since Sun Microsystems era and you will find different frameworks for different needs, for example, if we want to create a REST API with Java the first selection should be among:

* Microframeworks that provide an imperative programming model and HTTP communications like [SparkJava](https://sparkjava.com/) or [Javalin](https://javalin.io/)
* Opinionated end-to-end frameworks with their own mindset and way of doing things like [Armeria](https://armeria.dev/) or [Akka](https://akka.io/) 
* Generalistic end-to-end frameworks based on declarative programming (annotations), like [Spring Boot](https://spring.io/projects/spring-boot) or [Dropwizard](https://www.dropwizard.io/en/latest/)

With this in mind, a regular Java developer can't know every particular aspect of every framework, hence in many situations your knowledge about one solution is not portable at all to other solutions despite **both solutions being Java**.

What to do about it? In 1998 Sun Microsystems created the Java Community Process, a [standards organization](https://en.wikipedia.org/wiki/Standards_organization) aiming to provide a common set of technical specifications for Java Core (J2SE), Java Micro (J2ME) and Java Enterprise (J2EE). Fast forwarding to present times J2EE became Java EE, and some years later the [Java EE process was donated to the Eclipse [Foundation](https://www.infoq.com/news/2017/09/JavaEEtoEclipse/), where Jakarta EE was born. Within Eclipse, software providers (communities or companies) could take (or propose) a specification, aiming for technical common grounds to define a "Java enterprise way" of doing things.

A specification "product" is mostly (but not exclusively) four things, 1. A sub-project in charge of specification, basically a community composed of interested parties, 2. The specification definition (documentation about it), 3. A set of Java APIs and 4. A set of compatibility tests to validate eventual implementations (TCK).

### How Jakarta EE looks in the real life

Let's take one of the most popular Jakarta EE specifications, the specification for Java object persistence -i.e. **Jakarta Persistence**-. 

The definition states:

> Jakarta Persistence defines a standard for management of persistence and object/relational mapping in Java® environments.

As you probably guess, it has (at least) the four elements described previously, being:

1. [A community steering the specification](https://jakarta.ee/specifications/persistence/3.1/)
2. [The specification definition](https://jakarta.ee/specifications/persistence/3.1/jakarta-persistence-spec-3.1.html)
3. [A set of Java APIs](https://github.com/jakartaee/persistence/tree/master/api)
4. [A TCK](https://download.eclipse.org/jakartaee/persistence/3.1/jakarta-persistence-tck-3.1.0.zip)

Later or during the specification creation, communities and companies create Java libraries and/or products compatible with this specification, currently Jakarta Persistence 3.1 has two implementations:

1. [EclipseLink (Eclipse)](https://www.eclipse.org/eclipselink/releases/4.0.php)
2. [Hibernate (Red Hat)](https://hibernate.org/orm/releases/6.1/)

In practical terms, this means that EclipseLink and Hibernate as libraries provide the source code to satisfy the Jakarta Persistence objective, being tested against the TCK, and having a predictable behavior where your knowledge about Jakarta Persistence is universal. If you decide to stay in the specification, your code will be portable among implementations.

At the same time, each project provides extra capabilities like being compatible with some particular cache -e.g. [Infinispan and Hibernate](https://infinispan.org/docs/stable/titles/hibernate/hibernate.html)- or having extra features for some particular databases -e.g. [EclipseLink and Oracle](https://www.eclipse.org/eclipselink/documentation/2.5/solutions/oracledb.htm)-. If you decide to use the extra capabilities, your code probably won't be portable among implementations but it will have the **Enterprise way** of doing things.

### Collections of specifications and certified runtimes

Some Jakarta specifications are more popular than others, and **most importantly** not every Java community or company will adopt every especification. 

For example both [Spring Boot](https://spring.io/projects/spring-data-jpa) and [Micronaut](https://micronaut-projects.github.io/micronaut-data/latest/guide/#hibernate) offer abstraction data layers over JPA, but each community has its own way to define REST endpoints ([Spring](https://spring.io/guides/gs/rest-service/), [Micronaut](https://docs.micronaut.io/2.0.0.M2/api/io/micronaut/http/annotation/Controller.html)).

Still, if a given company or community decides to embrace Jakarta EE by selecting/implementing many specifications, it can be certified against [Jakarta EE profiles](https://jakarta.ee/release/10/):

* Jakarta EE Core: Offering a minimalistic set of specifications for REST services creation
* Jakarta EE Web: Offering a set of specifications for creating Web applications
* Jakarta EE Full: Offering a complete set of specifications for products that need to offer a robust set of feature for any kind of Java Enterprise applications

Again, a given product could target the minimum to comply with Jakarta EE Core, but still offer a lot of extras with its own mindset and not necesarly compatible with Jakarta EE Full, like Quarkus [which is planing to support Jakarta EE 10](https://es.quarkus.io/blog/our-bumpy-road-to-jakarta-ee-10/)).

## Bootstrapping new Jakarta EE 10 projects with Eclipse Starter for Jakarta EE

Although Java IDEs, communities and providers have templates to create new projects, one of the most "vendor-neutral" ways of doing it is by using **[Eclipse Starter for Jakarta EE](https://start.jakarta.ee/)**.

As the name suggests, the starter is a **web application directly available on Jakarta EE website**, you ony need to provide Maven coordinates (group, name, version) and choose between the available profiles (core, web or platform). It will generate a **new Maven project** compatible with major Java IDEs.

![Eclipse Starter for Jakarta EE](/images/posts/jakartaee/starter.png "Eclipse Starter for Jakarta EE")

The starter will generate a command to bootstrap the project using **Maven archetypes**. As an example, the execution described in the previous image will generate the following:

```prettyprint
mvn archetype:generate -DarchetypeGroupId=org.eclipse.starter -DarchetypeArtifactId=jakartaee10-minimal -DarchetypeVersion=1.1.0 -DgroupId=com.vorozco -DartifactId=demoee10 -Dprofile=web-api -Dversion=1.0.0-SNAPSHOT -DinteractiveMode=false
```

Once the project is ready, it will be compatible with any Maven aware IDE -e.g. Eclipse, NetBeans, IntelliJ, VSCode- and it should have the following structure:

![Project structure](/images/posts/jakartaee/structure.png "Project structure")

This project will include just one dependency over the desired Jakarta EE profile, and is quite usable on traditional application servers:

```prettyprint
...
<dependencies>
    <dependency>
        <groupId>jakarta.platform</groupId>
        <artifactId>jakarta.jakartaee-web-api</artifactId>
        <version>10.0.0</version>
        <scope>provided</scope>
    </dependency>
</dependencies>
...
```

Additionaly, it includes a JAX-RS resource (more on that later) with the following code snipet:

```prettyprint
@Path("hello")
public class RestResource {
    
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public HelloRecord hello(){
        return new HelloRecord("Hello from Jakarta EE");
    }
}
```

Depending on your IDE you should configure the connection to your application server to deploy the project. The following section traces some combinations among JVM, IDE and Application Server, but you could safely jump to the next section if you want to.

## Configuring applications servers and Java IDEs

By itself you won't find A UNIQUE Jakarta EE runtime, however and as described previously, nowadays these come in different flavors, being:

* Traditional application servers: **These are able to run MULTIPLE applications over the same JVM**. For development purposes, you commonly need to download and unzip the server, and for production, you will deploy the applications over an already running server. Over here you will find servers like Red Hat JBoss and Oracle WebLogic
* Micro runtimes: **These aim to run ONE application on a particular JVM**. For development purposes you pack an application with the help of Maven plugins -e.g. Payara Micro, Apache TomEE-. For production you'll distribute a .jar file that includes all of the dependencies needed to run your application, commonly named as FatJars or UberJars,
* Custom runtimes: **These also aim to run ONE application on a particular JVM**, however the main difference is about modularity. If compared with micro runtimes, a custom runtime will pack only the bare minimum set of dependencies to provide support for Jakarta EE APIs, in general this improves loading times but is a little bit difficult to configure. A good example of this is [Open Liberty](https://openliberty.io/) and [Piranha Core](https://piranha.cloud/core-profile/).

**For simplicity, this tutorial is focused on application servers**, but remember, the code will be the same on any of the runtimes if you remain in the domain of the specification :).

### Deploying a pristine project with NetBeans, Payara and Java 17

**Out of the box, NetBeans offers support for Jakarta EE projects and Payara**, to start using it you only require Java 11, and officialy supports Java 11 and Java 17. Hence the first step is to download it from [https://netbeans.apache.org/](https://netbeans.apache.org/)

![NetBeans Web](/images/posts/jakartaee/netbeansweb.png "NetBeans Web")

**You must download Payara** from [https://www.payara.fish/downloads/payara-platform-community-edition/](https://www.payara.fish/downloads/payara-platform-community-edition/), it offers zipfiles compatible with Web and Full profiles.

![Payara Web](/images/posts/jakartaee/payaraweb.png "Payara Web")

Payara installation steps are quite simple, you only need to unzip the file over a directory reachable by your IDE, hence not in root/Administrator reserved directories, and in the case of Windows using a not so deep path to avoid Windows issues with longer paths, specially with Maven.

As an example I've downloaded Payara Web, the zipfile was located at `/Users/tuxtor/Downloads/` (MacOS) and I wan't to unzip it over `/Users/tuxtor/opt/`. A couple of bash commands do the work:

```prettyprint
mv /Users/tuxtor/Downloads/payara-web-6.2023.1.zip /Users/tuxtor/opt/
unzip /Users/tuxtor/opt/payara-web-6.2023.1.zip
```

As result my Payara installation will be located at `/Users/tuxtor/opt/payara6`

![Payara](/images/posts/jakartaee/payarainstall.png "Payara")

Back to NetBeans and after running it for the first time, **it should look similar to this**. So please go directly to the Servers tab:

![Apache NetBeans](/images/posts/jakartaee/netbeans.png "Apache NetBeans")

Once there, a right-click will offer you to add a server, where you'll find Payara

![Apache NetBeans Servers](/images/posts/jakartaee/netbeanservers.png "Apache NetBeans Servers")

![Apache NetBeans Payara](/images/posts/jakartaee/netbeansglassfish.png "Apache NetBeans Payara")

Please also note, you could download Payara directly from here, however at the time I wrote this guide, the last version wasn't available. Hence you should locate Glassfish's path

### Deploying a pristine project with Eclipse, Wildfly and Java 17

### Deploying a pristine project with IntelliJ, Payara and Java 17




