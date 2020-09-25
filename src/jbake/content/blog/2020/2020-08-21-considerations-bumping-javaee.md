title=General considerations on updating Enterprise Java projects from Java 8 to Java 11
date=2020-09-23
type=post
tags=java
status=published
~~~~~~

![shell11](/images/posts/java8java11/shell11.png "shell11")


The purpose of this article is to **consolidate all difficulties and solutions that I've encountered while updating Java EE projects from Java 8 to Java 11 (and beyond)**. It's a known fact that Java 11 has a lot of new characteristics that are revolutionizing how Java is used to create applications, despite being problematic under certain conditions.

This article is focused on Java/Jakarta EE but it could be used as basis for other enterprise Java frameworks and libraries migrations.

## Is it possible to update Java EE/MicroProfile projects from Java 8 to Java 11?

Yes, absolutely. [My team](https://nabenik.com) has been able to bump at least two mature enterprise applications with more than three years in development, being:

### A Management Information System (MIS)

![Nabenik MIS](/images/posts/java8java11/erp-1024x508.png "Nabenik MIS")


* Time for migration: 1 week
* Modules: 9 EJB, 1 WAR, 1 EAR
* Classes: 671 and counting
* Code lines: 39480
* Project's beginning: 2014
* Original platform: Java 7, Wildfly 8, Java EE 7
* Current platform: Java 11, Wildfly 17, Jakarta EE 8, MicroProfile 3.0
* Web client: Angular

### Mobile POS and Geo-fence

![Medmigo REP](/images/posts/java8java11/rep-1024x467.png "Medmigo REP")

* Time for migration: 3 week
* Modules: 5 WAR/MicroServices
* Classes: 348 and counting
* Code lines: 17160
* Project's beginning: 2017
* Original platform: Java 8, Glassfish 4, Java EE 7
* Current platform: Java 11, Payara (Micro) 5, Jakarta EE 8, MicroProfile 3.2
* Web client: Angular

## Why should I ever consider migrating to Java 11?

As everything in IT the answer is "It depends . . .". However there are a couple of good reasons to do it:

1. Reduce [attack surface](https://securitytrails.com/blog/attack-surface) by updating project dependencies proactively
2. Reduce [technical debt](https://dzone.com/articles/dealing-technical-debt) and most importantly, prepare your project for the new and dynamic Java world
3. Take advantage of [performance improvements](https://optaweb.org/blog/2019/01/17/HowMuchFasterIsJava11.html) on new JVM versions
4. Take advantage from improvements of [Java as programming language](https://www.forbes.com/sites/oracle/2020/04/02/java-14-makes-code-super-expressive-say-top-developers/)
5. Sleep better by having a more secure, efficient and quality product

## Why Java updates from Java 8 to Java 11 are considered difficult?

From my experience with many teams, because of this:

### Changes in Java release cadence

![Java Release Cadence](/images/posts/java8java11/javareleasecadence.png "Java Release Cadence")

Currently, there are [two big branches in JVMs release model](https://www.oracle.com/java/technologies/java-se-support-roadmap.html):

* Java LTS: With a fixed lifetime (3 years) for long term support, being Java 11 the latest one
* Java current: A fast-paced Java version that is available every 6 months over a predictable calendar, being Java 15 the latest (at least at the time of publishing for this article)

The rationale behind this decision is that **Java needed dynamism in providing new characteristics to the language, API and JVM**, which I really agree.

Nevertheless, **it is a know fact that most enterprise frameworks seek and use Java for stability**. Consequently, most of these frameworks target Java 11 as "certified" Java Virtual Machine for deployments.

### Java Modules System in Java 9 and internal APIs

Errata: I [fixed this section following an interesting discussion on reddit :)](https://www.reddit.com/r/java/comments/iyknaa/general_considerations_on_updating_enterprise/)

![Java 9](/images/posts/java8java11/versiones-1024x516.png "Java 9")

**One of the critics over JVMs in the early days of containers was the monolithic distribution format**. Historically, Java Developer Kits were needed to deploy applications over servlet containers and application servers, but standard JDKs also included packages for AWT, Swing and Applets Execution (among others) which aren't mandatory for backend deployments.

Despite having alternatives like [Server JRE](https://www.oracle.com/java/technologies/javase-server-jre8-downloads.html) and [headless OpenJDK packages](https://pkgs.org/download/java-headless) in Linux distributions, Java was in need for a better way to create tailored JVM distributions with the minimal modules and smaller containers. **As consequence, we received Java 9 in 2017 with [Java Platform Modules System (JPMS)](https://en.wikipedia.org/wiki/Java_Platform_Module_System)** as flagship feature.

With JPMS, Java became modular to enable the creation of custom runtime JVM images with [JLink](https://docs.oracle.com/javase/9/tools/jlink.htm#JSWOR-GUID-CECAC52B-CFEE-46CB-8166-F17A8E9280E9), with proposed [restrictions over internal JVM packages by encapsulation of APIs](http://openjdk.java.net/jeps/260).

Turns out, during the proposal for encapsulation of internal modules some of these were found as critical with widespread usage, and **many popular libraries -e.g. Hibernate, ASM, Hazelcast- used these internals to gain performance, specially [sun.misc.unsafe](https://docs.google.com/document/d/1GDm_cAxYInmoHMor-AkStzWvwE9pw6tnz_CebJQxuUE/edit#heading=h.brct71tr6e13)**.

In the end, during the introduction of JEP-260 internal APIs were classified as critical and non-critical, consequently critical internal APIs for which replacements are introduced in JDK 9 are deprecated in JDK 9 and will be either encapsulated or removed in a future release.

Given that many of these modules like sun.misc.unsafe were proprietary and not meant for external usage, some of the implementation details changed and most of the runtimes had to wait/contribute to update these libraries for Java 9.

You are inside the danger zone if:

1. Your project compiles against dependencies pre-Java 9 depending on critical internals
2. You bundle dependencies pre-Java 9 depending on critical internals
3. You run your applications over a runtime -e.g. Application Servers- that include pre Java 9 transitive dependencies

Any of these situations means that your application has a probability of not being compatible with JVMs above Java 8. At least not without updating your dependencies, which also could uncover breaking changes in library APIs creating mandatory refactors.

### Removal of CORBA and Java EE modules from OpenJDK

![JEP230](/images/posts/java8java11/jep320.png "JEP230")

Also during Java 9 release, many Java EE and CORBA modules [were marked as deprecated](https://cr.openjdk.java.net/~iris/se/9/java-se-9-fr-spec/#APIs-proposed-for-removal), **being effectively [removed at Java 11](https://openjdk.java.net/jeps/320)**, specifically:

* java.xml.ws (JAX-WS, plus the related technologies SAAJ and Web Services Metadata)
* java.xml.bind (JAXB)
* java.activation (JAF)
* java.xml.ws.annotation (Common Annotations)
* java.corba (CORBA)
* java.transaction (JTA)
* java.se.ee (Aggregator module for the six modules above)
* jdk.xml.ws (Tools for JAX-WS)
* jdk.xml.bind (Tools for JAXB)

As JEP-320 states, many of these modules were included in Java 6 as a convenience to generate/support SOAP Web Services. But these modules eventually took off as independent projects already available at Maven Central. **Therefore it is necessary to include these as dependencies** if our project implements services with JAX-WS and/or depends on any library/utility that was included previously.

### IDEs and application servers

![Eclipse](/images/posts/java8java11/eclipse11.png "Eclipse")

In the same way as libraries, Java IDEs had to catch-up with the introduction of Java 9 at least in three levels:

1. IDEs as Java programs should be compatible with Java Modules
2. IDEs should support new Java versions as programming language -i.e. Incremental compilation, linting, text analysis, modules-
3. IDEs are also basis for an ecosystem of plugins that are developed independently. Hence if plugins have any transitive dependency with issues over JPMS, these also have to be updated

Overall, none of the Java IDEs guaranteed that plugins will work in JVMs above Java 8. Therefore you could possibly run your IDE over Java 11 but a legacy/deprecated plugin could prevent you to run your application.

## How do I update?

You must notice that Java 9 launched three years ago, hence the situations previously described are mostly covered. However you should do the following verifications and actions to prevent failures in the process:

1. Verify server compatibility
2. Verify if you need a specific JVM due support contracts and conditions
3. Configure your development environment to support multiple JVMs during the migration process
4. Verify your IDE compatibility and update
5. Update Maven and Maven projects
6. Update dependencies
7. Include Java/Jakarta EE dependencies
8. Execute multiple JVMs in production

### Verify server compatibility

![Tomcat](/images/posts/java8java11/tomcat.png "Tomcat")

**[Mike Luikides from O'Reilly affirms](https://www.oreilly.com/radar/rethinking-programming/) that there are two types of programmers**. In one hand we have the low level programmers that create tools as libraries or frameworks, and on the other hand we have developers that use these tools to create experience, products and services.

**Java Enterprise is mostly on the second hand, the "productive world" resting in giant's shoulders**. That's why you should check first if your runtime or framework already has a version compatible with Java 11, and also if you have the time/decision power to proceed with an update. If not, any other action from this point is useless.

The good news is that most of the popular servers in enterprise Java world are already compatible, like:

* [Apache Tomcat](http://tomcat.apache.org/whichversion.html)
* [Apache Maven](https://winterbe.com/posts/2018/08/29/migrate-maven-projects-to-java-11-jigsaw/)
* [Spring](https://spring.io/blog/2020/03/11/spring-tips-java-14-or-can-your-java-do-this)
* [Oracle WebLogic](https://docs.oracle.com/en/middleware/standalone/weblogic-server/14.1.1.0/notes/whatsnew.html)
* [Payara](https://blog.payara.fish/jdk-11-support-available-in-payara-platform-194)
* [Apache TomEE](http://tomee-openejb.979440.n4.nabble.com/Does-TomEE-8-0-0-run-on-Java-11-td4690633.html)
... among others

If you happen to depend on non compatible runtimes, **this is where the road ends unless you support the maintainer to update it**.

### Verify if you need an specific JVM

![FixesJDK15](/images/posts/java8java11/fixes.png "FixesJDK15")

On a non-technical side, under support contract conditions you could be obligated to use an specific JVM version.

**OpenJDK by itself is an open source project receiving contributions from many companies (being Oracle the most active contributor)**, but nothing prevents any other company to compile, pack and TCK other JVM distribution as demonstrated by [Amazon Correto](https://aws.amazon.com/corretto/), [Azul Zulu](https://www.azul.com/downloads/zulu-community/), [Liberica JDK](https://bell-sw.com/), etc.

In short, there is software that technically could run over any JVM distribution and version, but the support contract will ask you for a particular version. For instance:

* WebLogic is only [certified for Oracle HotSpot and GraalVM](https://docs.oracle.com/en/middleware/standalone/weblogic-server/14.1.1.0/notes/whatsnew.html#GUID-960100E8-DFC1-49E5-8CED-1EC1D883A42F)
* SAP Netweaver [includes by itself SAP JVM](https://wiki.scn.sap.com/wiki/display/ASJAVA/SAP%20JVM%20Netweaver%20compatibility%20and%20Installation)

### Configure your development environment to support multiple JDKs

Since the jump from Java 8 to Java 11 is mostly an experimentation process, it is a good idea to install multiple JVMs on the development computer, being SDKMan and jEnv the common options:

#### SDKMan

![sdkman](/images/posts/java8java11/sdkman.jpg "sdkman")

SDKMan is available for Unix-Like environments (Linux, Mac OS, Cygwin, BSD) and as the name suggests, acts as a Java tools package manager.

It helps to install and manage JVM ecosystem tools -e.g. Maven, Gradle, Leiningen- and also [multiple JDK installations](https://sdkman.io/jdks) from different providers.

#### jEnv

![jenv](/images/posts/java8java11/jenv.png "jenv")

Also available for Unix-Like environments (Linux, Mac OS, Cygwin, BSD), jEnv is basically a script to manage and switch multiple JVM installations per system, user and shell.

If you happen to install JDKs from different sources -e.g Homebrew, Linux Repo, Oracle Technology Network- it is a good choice.

Finally, if you use Windows the common alternative is to [automate the switch using .bat files](https://blogs.oracle.com/pranav/switch-between-different-jdk-versions-in-windows) however I would appreciate any other suggestion since I don't use Windows so often. 

### Verify your IDE compatibility and update

Please remember that any IDE ecosystem is composed by three levels:
 
1. The IDE acting as platform
2. Programming language support
3. Plugins to support tools and libraries

After updating your IDE, you should also verify if all of the plugins that make part of your development cycle work fine under Java 11.

### Update Maven and Maven projects

![maven](/images/posts/java8java11/maven.png "maven")


Probably the most common choice in Enterprise Java is Maven, and many IDEs use it under the hood or explicitly. Hence, you should update it.

Besides installation, please remember that Maven has a modular architecture and Maven modules version could be forced on any project definition. So, as rule of thumb you should also update these modules in your projects to the [latest stable version](https://maven.apache.org/pom-archives/default-plugins-LATEST/plugin-management.html).

To verify this quickly, you could use [versions-maven-plugin](https://www.mojohaus.org/versions-maven-plugin/):

```prettyprint
<plugin>
      <groupId>org.codehaus.mojo</groupId>
      <artifactId>versions-maven-plugin</artifactId>
      <version>2.8.1</version>
</plugin>
```

Which includes a specific goal to verify Maven plugins versions:

```prettyprint
mvn versions:display-plugin-updates
```

![mavenversions](/images/posts/java8java11/maven-versions-output.png "mavenversions")

After that, you also need to configure Java source and target compatibility, generally this is achieved in two points.

As properties:

```prettyprint
<properties>
        ...
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
</properties>
```

As configuration on Maven plugins, specially in maven-compiler-plugin:

```prettyprint
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.8.0</version>
    <configuration>
        <release>11</release>
    </configuration>
</plugin>
```

Finally, some plugins need to "break" the barriers imposed by Java Modules and Java Platform Teams knows about it. Hence JVM has an [argument called illegal-access](https://docs.oracle.com/javase/9/tools/java.htm#JSWOR624) to allow this, at least during Java 11.

This could be a good idea in plugins like surefire and failsafe which also invoke runtimes that depend on this flag (like Arquillian tests):

```prettyprint
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>2.22.0</version>
    <configuration>
        <argLine>
            --illegal-access=permit
        </argLine>
    </configuration>
</plugin>
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-failsafe-plugin</artifactId>
    <version>2.22.0</version>
    <configuration>
        <argLine>
            --illegal-access=permit
        </argLine>
    </configuration>
</plugin>
```

### Update project dependencies

As mentioned before, you need to check for compatible versions on your Java dependencies. Sometimes these libraries could introduce breaking changes on each major version -e.g. Flyway- and you should consider a time to refactor this changes.

Again, if you use Maven [versions-maven-plugin](https://www.mojohaus.org/versions-maven-plugin/) has a goal to verify dependencies version. The plugin will inform you about available updates.:

```prettyprint
mvn versions:display-dependency-updates
```

![mavendependency](/images/posts/java8java11/maven-dependency-update.png "mavendependency")

In the particular case of Java EE, you already have an advantage. **If you depend only on APIs -e.g. Java EE, MicroProfile- and not particular implementations, many of these issues are already solved for you**.

### Include Java/Jakarta EE dependencies

![jakarta](/images/posts/java8java11/jakarta.png "jakarta")


Probably modern REST based services won't need this, **however in projects with heavy usage of SOAP and XML marshalling is mandatory to include the Java EE modules removed on Java 11**. Otherwise your project won't compile and run.

You must include as dependency:

* API definition
* Reference Implementation (if needed)

**At this point is also a good idea to evaluate if you could move to Jakarta EE**, [the evolution of Java EE under Eclipse Foundation](https://dzone.com/articles/jakarta-ee-generation-iv-a-new-hope).

Jakarta EE 8 is practically Java EE 8 with another name, but it retains package and features compatibility, [most of application servers are in the process or already have Jakarta EE certified implementations](https://jakarta.ee/compatibility/):

We could swap the Java EE API:

```prettyprint
<dependency>
    <groupId>javax</groupId>
    <artifactId>javaee-api</artifactId>
    <version>8.0.1</version>
    <scope>provided</scope>
</dependency>
```

For Jakarta EE API:

```prettyprint
<dependency>
    <groupId>jakarta.platform</groupId>
    <artifactId>jakarta.jakartaee-api</artifactId>
    <version>8.0.0</version>
    <scope>provided</scope>
</dependency>
```

After that, please include any of these dependencies (if needed):

#### Java Beans Activation

Java EE

```prettyprint
<dependency>
    <groupId>javax.activation</groupId>
    <artifactId>javax.activation-api</artifactId>
    <version>1.2.0</version>
</dependency>
```

Jakarta EE

```prettyprint
<dependency>
    <groupId>jakarta.activation</groupId>
    <artifactId>jakarta.activation-api</artifactId>
    <version>1.2.2</version>
</dependency>
```

#### JAXB (Java XML Binding)

Java EE

```prettyprint
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.3.1</version>
</dependency>
```

Jakarta EE

```prettyprint
<dependency>
    <groupId>jakarta.xml.bind</groupId>
    <artifactId>jakarta.xml.bind-api</artifactId>
    <version>2.3.3</version>
</dependency>
```

Implementation

```prettyprint
<dependency>
    <groupId>org.glassfish.jaxb</groupId>
    <artifactId>jaxb-runtime</artifactId>
    <version>2.3.3</version>
</dependency>
```
#### JAX-WS

Java EE

```prettyprint
<dependency>
    <groupId>javax.xml.ws</groupId>
    <artifactId>jaxws-api</artifactId>
    <version>2.3.1</version>
</dependency>
```

Jakarta EE

```prettyprint
<dependency>
    <groupId>jakarta.xml.ws</groupId>
    <artifactId>jakarta.xml.ws-api</artifactId>
    <version>2.3.3</version>
</dependency>
```

Implementation (runtime)

```prettyprint
<dependency>
    <groupId>com.sun.xml.ws</groupId>
    <artifactId>jaxws-rt</artifactId>
    <version>2.3.3</version>
</dependency>
```

Implementation (standalone)

```prettyprint
<dependency>
    <groupId>com.sun.xml.ws</groupId>
    <artifactId>jaxws-ri</artifactId>
    <version>2.3.2-1</version>
    <type>pom</type>
</dependency>
```

#### Java Annotation

Java EE

```prettyprint
<dependency>
    <groupId>javax.annotation</groupId>
    <artifactId>javax.annotation-api</artifactId>
    <version>1.3.2</version>
</dependency>
```

Jakarta EE

```prettyprint
<dependency>
    <groupId>jakarta.annotation</groupId>
    <artifactId>jakarta.annotation-api</artifactId>
    <version>1.3.5</version>
</dependency>
```

#### Java Transaction

Java EE

```prettyprint
<dependency>
    <groupId>javax.transaction</groupId>
    <artifactId>javax.transaction-api</artifactId>
    <version>1.3</version>
</dependency>
```

Jakarta EE

```prettyprint
<dependency>
    <groupId>jakarta.transaction</groupId>
    <artifactId>jakarta.transaction-api</artifactId>
    <version>1.3.3</version>
</dependency>
```

### CORBA

In the particular case of CORBA, I'm aware of its adoption. [There is an independent project in eclipse to support CORBA](https://github.com/eclipse-ee4j/orb), based on Glassfish CORBA, but this should be investigated further.

## Multiple JVMs in production

If everything compiles, tests and executes. You did a successful migration.

Some deployments/environments run multiple application servers over the same Linux installation. **If this is your case it is a good idea to install multiple JVMs** to allow stepped migrations instead of big bang.

For instance, RHEL based distributions like [CentOS, Oracle Linux or Fedora](https://blogs.igalia.com/dpino/2011/10/13/configuring-different-jdks-with-alternatives/) include various JVM versions:

![olinux](/images/posts/java8java11/olinux.png "olinux")

Most importantly, If you install JVMs outside directly from RPMs(like Oracle HotSpot), Java alternatives will give you support:

![hotspot](/images/posts/java8java11/hotspot.png "hotspot")

**However on modern deployments probably would be better to use Docker, specially on Windows** which also needs .bat script to automate this task. Most of the JVM distributions are also available on Docker Hub:

![dockerjava](/images/posts/java8java11/dockerjava.png "dockerjava")