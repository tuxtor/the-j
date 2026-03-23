title=Notes on Java EE support for NetBeans 9
date=2018-07-30
type=post
tags=java
status=published
~~~~~~

Today one of my favourite open source projects got a major release, now under Apache Foundation, welcome back NetBeans!.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">The <a href="https://twitter.com/TheASF?ref_src=twsrc%5Etfw">@TheASF</a> <a href="https://twitter.com/netbeans?ref_src=twsrc%5Etfw">@NetBeans</a> community is proud to announce the 1st official release of <a href="https://twitter.com/TheASF?ref_src=twsrc%5Etfw">@TheASF</a> <a href="https://twitter.com/netbeans?ref_src=twsrc%5Etfw">@NetBeans</a> (incubating): <a href="https://t.co/GJLsExeWXO">https://t.co/GJLsExeWXO</a> Especially for devs, users, and students of JDK 8, 9, and 10. 100% free and open source and we welcome pull requests: <a href="https://t.co/AT39k8NCnO">https://t.co/AT39k8NCnO</a> <a href="https://t.co/Ae70AyqiGp">pic.twitter.com/Ae70AyqiGp</a></p>&mdash; Apache NetBeans (incubating) (@netbeans) <a href="https://twitter.com/netbeans/status/1023647803116015616?ref_src=twsrc%5Etfw">July 29, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


In this line, I think that the most frequent question since beta release is:

> What about Java EE/C++/PHP/JavaME . . .? You name it

**Quick response:**

**First source code donation to Apache includes only base NetBeans platform** modules plus Java SE support

**Long response:**

[Please see Apache Foundation official statement](https://blogs.apache.org/netbeans/entry/announce-apache-netbeans-incubating-92).

## Does it mean that I won't be able to develop my Java EE application on NetBeans 9

**Short answer:** No

**Long answer:** Currently Oracle already did a second donation, where most of NetBeans modules considered as external are included, as Apache statement suggests we could expect these modules on future NetBeans releases.

## Is it possible to enable Java EE support in NetBeans 9?

Considering that NetBeans has been modular since . . . ever, we could expect support for old modules in the new NetBeans version. As a matter of fact, **this is the official approach to enable Java EE support on NetBeans 9**, [by using kits](https://blogs.apache.org/netbeans/entry/what-s-happened-to-my).

Hence I've prepared a small tutorial to achieve this. This tutorial is focused on MacOS but steps should be exactly the same for Linux and Windows. To show some caveats, I've tested two app server over Java 8 and Java 10.

### Downloading NetBeans 9.0

First, you should download NetBeans package from official Apache Mirrors, at this time distributions are only available as .zip files.

![NetBeans 9 Download](/images/posts/nb9/nb9-download.png "NetBeans 9 download")

After download, just uncompress the .zip file

```bash
unzip incubating-netbeans-java-9.0-bin.zip
```

You should find a netbeans executable at `bin/` directory, for Unix:

```bash
cd netbeans
bin/netbeans
```

Whit this you would be able to run NetBeans 9. **By default, NetBeans will run on the most up-to date JVM available at system.**

![NetBeans 9](/images/posts/nb9/nb9.png "NetBeans 9")

### Enabling Java EE support

To install Java EE support you should enable also NetBeans 8.2 update center repository.

First go to `Tools > Plugins > Settings`.

Second, add a new update repository:

> http://updates.netbeans.org/netbeans/updates/8.2/uc/final/distribution/catalog.xml.gz

![NetBeans 8.2 update center](/images/posts/nb9/nb82update.png "NetBeans 8.2 update center")

![NetBeans 8.2 update center](/images/posts/nb9/nb82update2.png "NetBeans 8.2 update center")

Third, search for new plugins with the keyword "Kit", as the name suggests, **these are plugins collections for specific purposes**

![NetBeans 8.2 update center](/images/posts/nb9/nb82update3.png "NetBeans 8.2 update center")

From experience I do recommend the following plugins:

* HTML5 Kit
* JSF
* SOAP Web Services
* EJB and EAR
* RESTful Web Services
* Java EE Base

Restart the IDE and you're ready to develop apps with Java EE :).

## Test 1: Wildfly 13

To test NetBeans setup, I added a new application server and ran a recent Java EE 8 REST-CRUD application, [from recent jEspañol presentation](https://github.com/comunidad-hispana-jugs/workshop-03-JEE8_-_JSE10/blob/master/JEE_8/README.md) (in Spanish).

You have to select WildFly Application Server

![WildFly 13](/images/posts/nb9/wf1.png "WildFly 13")

As [WildFly release notes](http://wildfly.org/news/2018/05/30/WildFly13-Final-Released/) suggests if you wanna Java EE 8 support, you should choose `standalone-ee8.xml` as domain configuration.
![WildFly 13](/images/posts/nb9/wf2.png "WildFly 13")

Domain configuration will be detected by NetBeans 9

![WildFly 13](/images/posts/nb9/wf3.png "WildFly 13")

WildFly team has been working on Java 9 and 10 compatibility, hence application ran as expected delivering new records from in-memory database.

![WildFly 13](/images/posts/nb9/wf4.png "WildFly 13")

## Test 2: Glassfish 5 and Payara 5 on Java 10 (NetBeans) and Java 8 (App server platform)

To test vanilla experience, I tried to connect Payara and Glassfish 5 app server, as in the case of WildFly, configuration is pretty straight forward:

You have to select Payara Application Server
![Payara 5](/images/posts/nb9/py1.png "Payara 5")

Domain 1 default configuration should be ok
![Payara 5](/images/posts/nb9/py2.png "Payara 5")

Since Payara and Glassfish only support Java 8 ([Java 11 support is on the roadmap](https://blog.payara.fish/payara-server-and-payara-micro-in-2018)) you have to create a new platform with Java 8. Go to `Tools -> Java Platforms` and click on `Add Platform`
![Payara 5](/images/posts/nb9/py3.png "Payara 5")

Select a new Java SE Platform

![Payara 5](/images/posts/nb9/py4.png "Payara 5")

Pick the home directory for Java 8

![Payara 5](/images/posts/nb9/py6.png "Payara 5")

Finally, go to server properties and change Java Platform
![Payara 5](/images/posts/nb9/py7.png "Payara 5")

At this time, it seem that NetBeans should be running on Java 8 too, otherwhise you won't be able to retrieve server's configuration and logs, [there is a similar report on Eclipse Plugin](https://marketplace.eclipse.org/comment/4948#comment-4948).

![Payara 5](/images/posts/nb9/py8.png "Payara 5")

## Test 3: Glassfish 5 and Payara 5 on Java 8 (NetBeans) and Java 8 (App server platform)

Finally, I configured NetBeans to use JDK 8 as NetBeans JDK, for this, you sould edit `etc/netbeans.conf` file and point the `netbeans_jdkhome` variable to JDK 8, since I'm using jenv to manage JVM environments the right value is `netbeans_jdkhome="/Users/tuxtor/.jenv/versions/1.8"`

With this NetBeans 9 is able to run Payara 5 and Glassfish 5 as expected:

![Payara 5](/images/posts/nb9/py9.png "Payara 5")

I'm Still not sure about TomEE, OpenLiberty, WebSphere and WebLogic, but it seems like it would be a matter of hacking a litle bit on JDK versions.

Long live to NetBeans and Jakarta EE!
