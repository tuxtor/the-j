title=[Quicktip] How to install Oracle Java 9 on Fedora 26
date=2017-09-28
type=post
tags=java
status=published
~~~~~~

<a href="/images/posts/java9fedora26/duke9.png" data-lightbox="image-1" title="Java 9" >
  <img src="/images/posts/java9fedora26/duke9.png">
</a>

Yey! It's time to celebrate the general availability of Java 9.

Since I'm **the guy in charge of breaking the things before everyone else in the company**, I've been experimenting with JDK 9 and Fedora 26 Workstation, hence this quick guide about installing Oracle JDK 9 using the "Fedora Way".

# Getting the JDK

As always when a JDK reaches general availability, you could **download a Java Developer Kit from Oracle website**.

Here http://www.oracle.com/technetwork/java/javase/downloads/index.html

Conveniently **Oracle offers a .rpm package** that it's supposed to work with any "Hat" distribution. This guide is focused on that installer.

# Installing the new JDK

After downloading the rpm, **you could install it as any other rpm**, at the time of writing this tutorial, the rpm didn't required any other dependency (or any dependency not available in Fedora)

    sudo rpm -ivh jdk-9_linux-x64_bin.rpm

This command was executed as super user.

# Configuring the JDK
"Hat" distributions come with a handy tool called [alternatives](https://fedoraproject.org/wiki/Packaging:Alternatives), as the name suggests it handles the alternatives for the system, in this case the default JVM and compiler.

First, set the alternative for the `java` command

    sudo alternatives config --java

It will list the "Red Hat packaged" JVM's installed on the system, **for instance this is the output in my system (Oracle JDK 8, Oracle JDK 9, OpenJDK 8)**:


<a href="/images/posts/java9fedora26/alternativesjvm.png" data-lightbox="image-1" title="Java Alternatives" >
  <img src="/images/posts/java9fedora26/alternativesjvm.png">
</a>

Later, you should also pick a compiler alternative

    sudo alternatives config --javac


# Configuring JShell REPL

JShell is one of the coolest features in Java 9, **being the first official REPL to be included**. However and since it's the first time that the binary is available in the system, it cannot be selected as alternative unless you create it manually.

First, locate the JDK install directory, Oracle JDK is regularly located at `/usr/java`, being in my system.

<a href="/images/posts/java9fedora26/jdklist.png" data-lightbox="image-1" title="JDK List" >
  <img src="/images/posts/java9fedora26/jdklist.png">
</a>

As any other JVM binary program, JShell will be located at `bin` directory, hence to create an alternative (and consequently to be prepared for other Java 9 options . . . and to include the executable in the path):

    sudo alternatives --install /usr/bin/jshell jshell /usr/java/jdk-9/bin/jshell

From now on you could use jshell on any regular shell, just **see my first Java-9 hello world, it looks beautiful :-)**.

<a href="/images/posts/java9fedora26/hello9.png" data-lightbox="image-1" title="Java 9 Hello World" >
  <img src="/images/posts/java9fedora26/hello9.png">
</a>
