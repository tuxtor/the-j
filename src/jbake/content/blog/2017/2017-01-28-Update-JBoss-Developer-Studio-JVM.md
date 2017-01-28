title=[Quicktip] Move current JVM on JBoss Developer Studio
date=2017-01-28
type=post
tags=java
status=published
~~~~~~


<a href="/images/posts/jbossemc/devstudio10.png" target="_blank">
    <img src="/images/posts/jbossemc/devstudio10.png" alt="JBoss Developer Studio" style="width: 300px;"/>
</a>

After a routinary JVM update I had the idea of getting rid of old JVMs by simply removing the install directories. **After that many of my Java tools went dark :(**.

For JBoss Developer Studio, I recevied the following "welcome message".

<a href="/images/posts/jbossjvm/jvmwarn.png" data-lightbox="image-1" title="devstudio-jvm-error" >
  <img src="/images/posts/jbossjvm/jvmwarn.png">
</a>

At the time, I deleted the 1.8.111 version from my system, preserving only the 1.8.121 version as the "actual" version.

##Fixing versions
Different from other tools, Eclipse-based tools tend to "hardcode" the JVM location with the install process inside eclipse.ini file. However and as I stated in a [previous entry](/blog/2016/2016-02-02-Fix-font-size-JBoss-Developer-OSX.html), JBoss Developer Studio converts this file to **jbdevstudio.ini, hence you should fix the JVM location in this file**.

##Finding the file in Mac OS(X?)
If you got JDevStudio with the vanilla installer, the default location for the IDE would be /Applications/devstudio and the tricky part is that **configuration is inside "Devstudio" OSX Package**.

If you wanna fix this file from terminal the **complete path for the file would be:**

`/Applications/devstudio/studio/devstudio.app/Contents/Eclipse`

Of course you could always open packages in Finder:

<a href="/images/posts/jbossjvm/pcontents.png" data-lightbox="image-1" title="finder-package" >
  <img src="/images/posts/jbossjvm/pcontents.png">
</a>

After opening the file the only fix that you need to do is to **point to the installed virtual machine**, being in my PC (Hint: You could check the location by executing /usr/libexec/java_home):

`/Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/`


And your file should look like this:

<a href="/images/posts/jbossjvm/devstudio.png" data-lightbox="image-1" title="jvm-location" >
  <img src="/images/posts/jbossjvm/devstudio.png">
</a>
