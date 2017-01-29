title=[Quicktip] Fix font size in JBoss Developer Studio and OSX
date=2016-02-02
type=post
tags=java
status=published
~~~~~~


<a href="/images/posts/jbossdeveloper/jbds9.png" target="_blank">
	<img src="/images/posts/jbossdeveloper/jbds9.png" alt="JBoss Developer Studio" style="width: 300px;"/>
</a>

One of the most annoying things of using JBoss Developer Studio on OSX is the **default configuration**, specially the font size.

By default Eclipse (and consequently Jbossdevstudio) has a startup parameter called ["-Dorg.eclipse.swt.internal.carbon.smallFonts"](https://bugs.eclipse.org/bugs/show_bug.cgi?id=56558) and as its name suggests, it enforces the usage of the smallest font at the system. 


Although default settings are tolerable on retina displays:
<a href="/images/posts/jbossdeveloper/retinagood.png" data-lightbox="image-1" title="1080p bad fonts" >
  <img src="/images/posts/jbossdeveloper/retinagood.png">
</a>

The problem gets worse on regular 1080p screens (like external non-mac displays):

<a href="/images/posts/jbossdeveloper/1080pbad.png" data-lightbox="image-2" title="1080p bad fonts" >
  <img src="/images/posts/jbossdeveloper/1080pbad.png">
</a>

As you probably guess the solution of this issue is to delete the parameter, but the tricky part is that **JBoss Developer Studio renames the eclipse.ini file (default Eclipse configuration) to jbdevstudio.ini**, making most of the how-to guides at internet "complicated".

Anyway the file is located at:

    ${JBDEVSTUDIO_HOME}/studio/jbdevstudio.app/Contents/Eclipse/jbdevstudio.ini

Being the default location:
    
    /Applications/studio/jbdevstudio.app/Contents/Eclipse/jbdevstudio.ini
    
With this **your eyes will be gratefull** (actual 1080p screenshot):

<a href="/images/posts/jbossdeveloper/1080pgood.png" data-lightbox="image-3" title="1080p good fonts" >
  <img src="/images/posts/jbossdeveloper/1080pgood.png">
</a>

