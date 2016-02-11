title=First impressions of Zulu on OSX
date=2016-02-11
type=post
tags=java
status=published
~~~~~~


<a href="/images/posts/zulufirst/zulu.jpg" target="_blank">
	<img src="/images/posts/zulufirst/zulu.jpg" alt="Zulu" style="width: 300px;"/>
</a>

Although my first development box at this time is an Apple PC, **I'm pretty comfortable with Open Source** software due [technical and security benefits](http://opensourceforamerica.org/learn-more/benefits-of-open-source-software/).

In this line, I've been a user of [Zulu JVM](https://www.azul.com/products/zulu/) on my Windows+Java deployments, basically because **Zulu offers a zero-problems deployment of [OpenJDK](http://openjdk.java.net/)**, being at this time the only Open Source and production ready JVM available for Windows (in Linux you also have OpenJDK distro builds or IcedTea).

As my previous experiences in Windows and considering that Zulu is at some point a supported compilation of OpenJDK (basis for HotSpot aka OracleJDK), using Zulu **in OSX has been so far a painless solution**.

Compared to HotSpot you have **an additional security "feature"** only available at [Server JRE](http://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html), the lack of the infamous web plugin, however you will lose Java Mission Control because is a closed source tool.

If you are interested in **formal benchmarks** this guide (by Zulu creators BTW) could be helpful: http://www.azulsystems.com/sites/default/files/images/Azul_Zulu_Hotspot_Infographic_d2_v2.pdf

In a more "day by day" test, no matter if you are using Eclipse

<a href="/images/posts/zulufirst/eclipse.png" data-lightbox="eclipse" title="eclipse" >
  <img src="/images/posts/zulufirst/eclipse.png">
</a>

Wildfly

<a href="/images/posts/zulufirst/wildfly.png" data-lightbox="wildfly" title="wildfly" >
  <img src="/images/posts/zulufirst/wildfly.png">
</a>

Or maybe Vuze

<a href="/images/posts/zulufirst/vuze.png" data-lightbox="vuze" title="vuze" >
  <img src="/images/posts/zulufirst/vuze.png">
</a>

Zulu simply works.

¿Why should you consider Zulu?
===================
* Is based on OpenJDK Open Source project
* You obtain nearly the same performance of HotSpot
* You can bundle it on your apps (like [Microsoft in Azure](https://azure.microsoft.com/en-us/marketplace/partners/azul/zulu-enterprise-ondemand-ub1404/))

¿Why avoid Zulu?
===================
* If you need Java Mission Control
* If you need the Java Browser Plugin, [pretty dead BTW](http://www.theverge.com/2016/1/28/10858250/oracle-java-plugin-deprecation-jdk-9)
