title=Getting started with Java EE 8, Payara 5 and Eclipse Oxygen
date=2018-06-04
type=post
tags=java
status=published
~~~~~~

Some days ago I had the opportunity/obligation to setup a brand new Linux(Gentoo) development box, hence to make it "enjoyable" **I prepared a back to basics tutorial on how to setup a working environment**.

# Requirements

In order to setup a complete Java EE development box, you need at least:

1- Working JDK installation and environment
2- IDE/text editor
3- Standalone application server if your focus is "monolithic"

Due personal preferences I choose

1- OpenJDK on Gentoo Linux (Icedtea bin build)
2- Eclipse for Java EE developers
3- Payara 5

# Installing OpenJDK

Since this is a distribution dependent step, you could follow tutorials on [Ubuntu, CentOS, Debian](http://openjdk.java.net/install/) and many more distributions if you need to. At this time, **most application servers have Java 8 as target due new Java-LTS version scheme**, as in the case of Payara.

<a href="/images/posts/payara5/00.png" data-lightbox="Gentoo" title="Gentoo" >
  <img class="img-fluid" src="/images/posts/payara5/00.png">
</a>


For Gentoo Linux you could get a new OpenJDK setup by installing [dev-java/icedtea](https://packages.gentoo.org/packages/dev-java/icedtea) for the source code version and [dev-java/icedtea-bin](https://packages.gentoo.org/packages/dev-java/icedtea-bin) for the precompiled version.

	emerge dev-java/icedtea-bin

## Is OpenJDK a good choice for my need?

Currently [Oracle has plans to free up all enterprise-commercial JDK features](https://blogs.oracle.com/java-platform-group/update-and-faq-on-the-java-se-release-cadence). In a near future the differences between OracleJDK and OpenJDK should be zero.

In this line, Red Hat and other big players have been offering OpenJDK as the standard JDK in Linux distributions, **working flawlessly for many enterprise grade applications**.

# Eclipse for Java EE Developers
After a complete revamp of websites GUI, you could go directly to [eclipse.org](https://eclipse.org) website and download Eclipse IDE. 

Eclipse offers collections of plugins denominated *Packages*, **each package is a collection of common plugins aimed for a particular development need**. Hence to simplify the process you could download directly Eclipse IDE for Java EE Developers.

<a href="/images/posts/payara5/01.png" data-lightbox="Eclipse" title="Eclipse" >
  <img class="img-fluid" src="/images/posts/payara5/01.png">
</a>

On Linux, you will download a .tar.gz file, hence you should uncompress it on your preferred directory.

	tar xzvf eclipse-jee-oxygen-3a-linux-gtk-x86_64.tar.gz

Finally, you could execute the IDE by entering the *bin* directory and launching `eclipse` binary.

	cd eclipse/bin
	./eclipse

The result should be a brand new Eclipse IDE.



<a href="/images/posts/payara5/03.png" data-lightbox="image-1" title="Pick font" >
  <img class="img-fluid" src="/images/posts/payara5/03.png">
</a>

# Payara

You could grab a fresh copy of Payara by visiting [payara.fish](https://payara.fish) website. 

<a href="/images/posts/payara5/02.png" data-lightbox="Payara" title="Payara" >
  <img class="img-fluid" src="/images/posts/payara5/02.png">
</a>

From Payara's you will receive a zipfile that again you should uncompress in your preferred directory.


	unzip payara-5.181.zip

Finally, you could add Payara's bin directory to PATH variable in order to use `asadmin` command from any CLI. You could achieve this by using ~/.bashrc file. For example if you installed Payara at ~/opt/ the complete instruction is:

	echo "PATH=$PATH:~/opt/payara5/bin" >> ~/.bashrc

# Integration between Eclipse and Payara

After unzipping Payara you are ready to integrate the app server in your Eclipse IDE.

Recently and due Java/Jakarta EE transition, [Payara Team has prepared a new integration plugin compatible with Payara 5](https://blog.payara.fish/payara-tools-unlocks-eclipse-for-payara-5). In the past you would also use Glassfish Developer Tools with Payara, but **this is not possible anymore**.

To install it, simply grab the following button on your Eclipse Window, and follow wizard steps.

<a href="http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=4014208" class="drag" title="Drag to your running Eclipse* workspace. *Requires Eclipse Marketplace Client"><img typeof="foaf:Image" class="img-responsive" src="https://marketplace.eclipse.org/sites/all/themes/solstice/public/images/marketplace/btn-install.png" alt="Drag to your running Eclipse* workspace. *Requires Eclipse Marketplace Client" /></a>


<a href="/images/posts/payara5/w1.png" data-lightbox="pwizard" title="pwizard" >
  <img class="img-fluid" src="/images/posts/payara5/w1.png">
</a>

<a href="/images/posts/payara5/w2.png" data-lightbox="pwizard2" title="pwizard" >
  <img class="img-fluid" src="/images/posts/payara5/w2.png">
</a>

In the final step you will be required to restart Eclipse, after that you still need to add the application server. **Go to the Servers tab and click create a new server**:

<a href="/images/posts/payara5/ns0.png" data-lightbox="ns0" title="ns0" >
  <img class="img-fluid" src="/images/posts/payara5/ns0.png">
</a>

Select Payara application server:

<a href="/images/posts/payara5/ns1.png" data-lightbox="ns1" title="ns1" >
  <img class="img-fluid" src="/images/posts/payara5/ns1.png">
</a>

Find Payara's install location and JDK location (corresponding to ~/opt/payara5 and /opt/icedtea-bin on my system):

<a href="/images/posts/payara5/ns2.png" data-lightbox="ns2" title="ns2" >
  <img class="img-fluid" src="/images/posts/payara5/ns2.png">
</a>

Configure Payara's domain, user and password.

<a href="/images/posts/payara5/ns3.png" data-lightbox="ns3" title="ns3" >
  <img class="img-fluid" src="/images/posts/payara5/ns3.png">
</a>

In the end, you will have Payara server available for deployment:

<a href="/images/posts/payara5/ns4.png" data-lightbox="ns4" title="ns4" >
  <img class="img-fluid" src="/images/posts/payara5/ns4.png">
</a>

# Test the demo environment 
It's time to give it a try. **We could start a new application with a Java EE 8 archetype**, one of my favorites is Adam Bien's [javaee8-essentials-archetype](https://mvnrepository.com/artifact/com.airhacks/javaee8-essentials-archetype), wich provides you an opinionated essentials setup.

First, create a new project and select a new Maven Project:

<a href="/images/posts/payara5/arch0.png" data-lightbox="arch0" title="arch0" >
  <img class="img-fluid" src="/images/posts/payara5/arch0.png">
</a>

In Maven's window you could search by name any archetype in Maven central, however you should wait a little bit for synchronization between Eclipse and Maven.

<a href="/images/posts/payara5/arch1.png" data-lightbox="arch1" title="arch1" >
  <img class="img-fluid" src="/images/posts/payara5/arch1.png">
</a>

If waiting is not your thing. You could also add the archetype directly:

<a href="/images/posts/payara5/arch2.png" data-lightbox="arch2" title="arch2" >
  <img class="img-fluid" src="/images/posts/payara5/arch2.png">
</a>

This archetype also creates a new JAX-RS application and endpoint, after some minor modifications just deploy it to Payara 5 and see the results:

<a href="/images/posts/payara5/arch3.png" data-lightbox="arch3" title="arch3" >
  <img class="img-fluid" src="/images/posts/payara5/arch3.png">
</a>



<a href="/images/posts/payara5/arch4.png" data-lightbox="arch4" title="arch4" >
  <img class="img-fluid" src="/images/posts/payara5/arch4.png">
</a>






