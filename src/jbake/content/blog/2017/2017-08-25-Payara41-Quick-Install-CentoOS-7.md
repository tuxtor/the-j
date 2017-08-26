title=Payara 4.1 install guide on CentOS 7
date=2017-08-25
type=post
tags=java
status=published
~~~~~~

<a href="/images/posts/payara/payara.png" data-lightbox="image-1" title="Payara" >
  <img src="/images/posts/payara/payara.png">
</a>

In this "back to basics tutorial" I'll try to explain **how to install properly Payara 4.1 on Centos 7** (it should be fine for Red Hat, Oracle Unbreakable Linux and other *hat distributions).

Why not Docker, Ansible, Chef, Puppet, . . .?. Sometimes the best solution is the easiest :).

Pre-requisites
==============
The only software requirement to run Payara is to **have a JDK installed**. CentOS offers a custom OpenJDK build called ["headless"](https://centos.pkgs.org/7/centos-x86_64/java-1.8.0-openjdk-headless-1.8.0.102-4.b14.el7.x86_64.rpm.html) that doesn't offer support for audio and video, perfect for cli environments.

You can install it with Yum.

    yum install java-1.8.0-openjdk-headless

Create a Payara user
====================
As mentioned in the official [Glassfish documentation](https://javaee.github.io/glassfish/documentation), it is convenient to **run your application server in a dedicated user** for security and administrative reasons.

    adduser payara

Although you could be tempted to create a no-login, no-shell user, Payara saves many preferences in user's home directory and **the shell/login is actually needed to execute administrative commands like `asadmin`**.

Download and unzip Payara
=========================
Payara is hosted at Amazon S3, please double check this link on [Payara's website](https://www.payara.fish/), for this guide I'm installing Payara at server's `/opt` directory.

    cd /opt
    wget https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/Payara+4.1.2.173/payara-4.1.2.173.zip
    unzip payara-4.1.2.173.zip

You should execute the above commands as super-user, after that **you should change permissions for the Payara directory before any domain start**. Otherwise you won't be able to use the server with `payara` user

    chmod payara:payara payara41

systemd unit
============

Centos 7 uses systemd as init system, consequently it is possible and actually quite easy to create a **systemd unit to start, stop and restart Payara default domain**
.
First, create a file that represents Payara systemd unit.

    /etc/systemd/system/payara.service

And add the following content:

    [Unit]
    Description = Payara Server v4.1
    After = syslog.target network.target

    [Service]
    User=payara
    ExecStart = /usr/bin/java -jar /opt/payara41/glassfish/lib/client/appserver-cli.jar start-domain
    ExecStop = /usr/bin/java -jar /opt/payara41/glassfish/lib/client/appserver-cli.jar stop-domain
    ExecReload = /usr/bin/java -jar /opt/payara41/glassfish/lib/client/appserver-cli.jar restart-domain
    Type = forking

    [Install]
    WantedBy = multi-user.target


Note that Payara administration is achieved with `payara` user. You could personalize it to fit your needs.

Optionally you could enable the service to start with the server and/or after server reboots.

    systemctl enable payara

Check if all is working properly with the systemd standard commands

    systemctl start payara
    systemctl restart payara
    systemctl stop payara

Payara user PATH
================
As Payara and Glassfish users already know, **most administrative tasks in Payara application server are achieved by using cli commands** like `asadmin`. Hence it is convenient to have all tools available in our administrative `payara` user.

First log-in as Payara user, if you didn't assign a password for the user you could switch to this user using `su` as root user.

    su payara

Later you shoud create or edit the `.bashrc` file for the Payara user, the most common location being user's home directory.

    cd /home/payara
    vim .bashrc

And add the following line:

    export PATH=$PATH:/opt/payara41/glassfish/bin

Final result
============
If your setup was done properly you should obtain an environment like in the following screenshot:

<a href="/images/posts/payara/payarafinish.png" data-lightbox="image-1" title="Payara Centos 7" >
  <img src="/images/posts/payara/payarafinish.png">
</a>

Note that:

* I'm able to use systemd commands
* It actually restarded since PID changed after `systemd restart`
* `asadmin` works and displays properly the running domain
