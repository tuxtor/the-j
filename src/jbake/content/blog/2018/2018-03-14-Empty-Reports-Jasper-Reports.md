title=Fixing missing data on Jasper Reports with community Linux distros
date=2018-03-14
type=post
tags=java
status=published
~~~~~~
. . . or why my report is half empty in Centos 7.

One of the most common and least emotional tasks in any enterprise software is to produce reports. However after many years today I got **my first "serious bug" in Jasper Reports.**

# The problem
My development team is composed by a mix of Ubuntu and Mac OS workstations, hence we could consider that we use user-friendly environments. Between many applications, we have in maintenance mode a not-so small accounting module which produces a considerable amount of reports. This applications is running (most of the times) on Openshift (Red Hat) platforms or on-premise (also Red Hat).

A recent deployment was carried over a headless(pure cli) CentOS 7 fresh install and after deploying application on the app server, all reports presented the following issue:

Good report, Red Hat, Mac Os, Ubuntu
<a href="/images/posts/jasper/goodreport.png" data-lightbox="image-1" title="Good Report" >
  <img class="img-fluid" src="/images/posts/jasper/goodreport.png">
</a>

Bad report, Centos 7
<a href="/images/posts/jasper/badreport.png" data-lightbox="image-1" title="Bad Report" >
  <img class="img-fluid" src="/images/posts/jasper/badreport.png">
</a>

At first sight both reports are working and equal, however **in the Centos 7 version, all quantities disappeared** and the only "meaningful" log message related to fonts was:

> [org.springframework.beans.factory.xml.XmlBeanDefinitionReader] (default task-1) Loading XML bean definitions from URL [vfs:/content/erp-ear.ear/core-web.war/WEB-INF/lib/DynamicJasper-core-fonts-1.0.jar/fonts
/fonts1334623843090.xml]

# Fons in Java

After many unsuccessful tests like deploying a new application server version, I learnt a little bit about fonts in the Java virtual machine and Jasper Reports.

According to [Oracle official](https://docs.oracle.com/javase/8/docs/technotes/guides/intl/font.html
) documentation, you basically have four rules while using fonts in Java, being:

1. Java supports only TTF and Postscript type 1 fonts
2. The only font family included in JDK is Lucida
3. If not Lucida JDK will depend on operating system fonts
4. Java applications will fallback to the sans/serif default font if the required font is not present on the system

And if you are a Jaspersoft Studio, it makes easy for you to pick Microsoft's True Type fonts

<a href="/images/posts/jasper/pickfont.png" data-lightbox="image-1" title="Pick font" >
  <img class="img-fluid" src="/images/posts/jasper/pickfont.png">
</a>

# My CentOS 7 solution

Of course Jasper Reports has [support for embedding fonts](https://community.jaspersoft.com/wiki/custom-font-font-extension), however report's font was not Lato, Roboto or Sage, **it was the omnipresent Verdana** part of the ["Core fonts for the web"](https://en.wikipedia.org/wiki/Core_fonts_for_the_Web) from Microsoft, not included in most Unix variant [due license restrictions](https://blogs.oracle.com/solaris/truetype-fonts-v2).

Let's assume that nowadays MS Core Fonts are a gray area and you are actually able to install these by using repackaged versions, like mscorefonts2 at sourceforge.

In CentOS is easy as 1) install dependencies,

    yum install curl cabextract xorg-x11-font-utils fontconfig

2) download the [repackaged fonts](http://mscorefonts2.sourceforge.net/)

    wget https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-2.1-1.noarch.rpm

3) and install the already available rpm file

    yum install msttcore-fonts-2.1-1.noarch.rpm


With this, all reports were fixed. I really hope that you were able to found this post before trying anything else.
