title=How to install Payara 5 with NGINX and Let's Encrypt over Oracle Linux 7.x
date=2019-05-02
type=post
tags=java
status=published
~~~~~~

![Payara SSL](/images/posts/reversepayara/payarassl.png "Payara SSl")

From field experiences I must affirm that one of the greatest and stable combinations is Java Application Servers + Reverse Proxies, although some of the functionality is a clear overlap, I tend to put reverse proxies in front of application servers for the following reasons ([please see NGINX page for more details](https://www.nginx.com/resources/glossary/reverse-proxy-server/)):

* **Load balancing:** The reverse proxy acts as traffic cop and could be used as API gateway for clustered instances/backing services
* **Web acceleration:** Most of our applications nowadays use SPA frameworks, hence it is worth to cache all the js/css/html files and free the application server from this responsibility
* **Security:** Most of the HTTP requests could be intercepted by the reverse proxy **before** any attempt against the application server, increasing the opportunity to define rules
* **SSL Management:** It is easier to install/manage/deploy OpenSSL certificates in Apache/NGINX if compared to [Java KeyStores](https://en.wikipedia.org/wiki/Java_KeyStore). Besides this, [Let's Encrypt](https://letsencrypt.org/) officially support NGINX with plugins.

## Requirements

To demonstrate this functionality, this tutorial combines the following stack in a classic (non-docker) way, however most of the concepts could be useful for Docker deployments:

* Payara 5 as application server
* NGINX as reverse proxy
* Let's encrypt SSL certificates

It is assumed that a clean Oracle Linux 7.x (7.6) box will be used during this tutorial and tests will be executed over Oracle Cloud with `root` user.

![Oracle Linux](/images/posts/reversepayara/oraclelinux.png "Oracle Linux")

## Preparing the OS

Since Oracle Linux is binary compatible with RHEL, [EPEL](https://fedoraproject.org/wiki/EPEL) repository will be added to get access to Let's Encrypt. It is also useful to update the OS as a previous step:

```prettyprint
yum -y update
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

## Setting up Payara 5

In order to install Payara application server a couple of dependencies will be needed, specially a Java Developer Kit. For instance OpenJDK is included at Oracle Linux repositories.

```prettyprint
yum -y install java-1.8.0-openjdk-headless
yum -y install wget
yum -y install unzip
```

Once all dependencies are installed, it is time to download, unzip and install Payara. It will be located at `/opt` following standard Linux conventions for external packages:

```prettyprint
cd /opt
wget -O payara-5.191.zip https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/5.191/payara-5.191.zip
unzip payara-5.191.zip
rm payara-5.191.zip
```

It is also useful to create a `payara` user for administrative purposes, to administrate the domain(s) or to run Payara as Linux service with systemd:

```prettyprint
adduser payara
chown -R payara:payara payara5
echo 'export PATH=$PATH:/opt/payara5/glassfish/bin' >> /home/payara/.bashrc
chown payara:payara /home/payara/.bashrc
```

A systemd unit is also needed:

```prettyprint
echo '[Unit]
Description = Payara Server v5
After = syslog.target network.target

[Service]
User=payara
ExecStart = /usr/bin/java -jar /opt/payara5/glassfish/lib/client/appserver-cli.jar start-domain
ExecStop = /usr/bin/java -jar /opt/payara5/glassfish/lib/client/appserver-cli.jar stop-domain
ExecReload = /usr/bin/java -jar /opt/payara5/glassfish/lib/client/appserver-cli.jar restart-domain
Type = forking

[Install]
WantedBy = multi-user.target' > /etc/systemd/system/payara.service
systemctl enable payara
```

Additionally if remote administration is needed, secure admin should be enabled:

```prettyprint
sudo -u payara /opt/payara5/bin/asadmin --host localhost --port 4848 change-admin-password
systemctl start payara
sudo -u payara /opt/payara5/bin/asadmin --host localhost --port 4848 enable-secure-admin
systemctl restart payara
```

![Payara Boot](/images/posts/reversepayara/payaraboot.png "Payara Boot")

Oracle Cloud default configuration will create a VNIC attached to your instance, hence you should check the rules in order to allow access to ports.

![Ingres Rules](/images/posts/reversepayara/ingresrules.png "Ingres Rules")

By default, Oracle Linux instances have a restricted set of rules in iptables and SELinux, hence ports should be opened with firewalld and SELinux should be configured to allow reverse proxy traffic:

```prettyprint
firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --zone=public --permanent --add-port=4848/tcp
setsebool -P httpd_can_network_connect 1
```

With this, the access is guaranteed to http+https+payara admin port.

## Setting up NGINX reverse proxy

NGINX is available at EPEL:

```prettyprint
yum -y install nginx
systemctl enable nginx
```

At this time your will need a FQDN pointing to your server, otherwhise Let's encrypt validation won't work. For this tutorial the `ocl.nabenik.com` domain will be used. If your domain propagated properly you should see a page like this:

![NGINX Proxy](/images/posts/reversepayara/nginxproxy.png "NGINX Proxy")

Don't worry the Fedora logo is due EPEL usage, but you're running Oracle Linux :).

Now it's time to setup NGINX as reverse proxy, an opinionated deployment option is to create a `/etc/nginx/sites-available` and `/etc/nginx/sites-enabled` structure inside NGINX configuration, to isolate/manage multiple domains with the same instance (aka virtual hosts).

```prettyprint
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled
mkdir -p /var/www/ocl.nabenik.com/
chown -R nginx:nginx /var/www/ocl.nabenik.com

echo 'server {
    server_name ocl.nabenik.com;

    gzip on;
    gzip_types      text/css text/javascript text/plain application/xml;
    gzip_min_length 1000;

    location ^~ /.well-known/acme-challenge/ {
        allow all;
        root /var/www/ocl.nabenik.com/;
        default_type "text/plain";
        try_files $uri =404;
    }

    location / {
        proxy_pass             http://localhost:8080;
        proxy_connect_timeout       300;
        proxy_send_timeout          300;
        proxy_read_timeout          300;
        send_timeout                300;
    }

    error_page  500 502 503 504  /50x.html;
    location = /50x.html {
        root  /usr/share/nginx/html;
    }

    listen 80;
}' > /etc/nginx/sites-available/ocl.nabenik.com.conf
```

To enable the new host, a symlink is created on `sites-enabled`:

```prettyprint
ln -s /etc/nginx/sites-available/ocl.nabenik.com.conf /etc/nginx/sites-enabled/ocl.nabenik.com.conf
```

After that you should include the following line inside `/etc/nginx/nginx.conf`, just before config file ending.

    include /etc/nginx/sites-enabled/*.conf;

It is also useful to check your configuration with `nginx -t`, if all works property you should reach payara after NGINX reload.

![Reverse Payara](/images/posts/reversepayara/reversepayara.png "Reverse Payara")


## Setting up Let's Encrypt

Once the reverse proxy is working, certbot should be enough to add an SSL certificate, the plugin itself will create a challenge at `^~ /.well-known/acme-challenge/`, hence the proxy exclusion is mandatory (as reflected in the previous configuration step).

```prettyprint
yum install -y certbot-nginx
certbot --nginx -d ocl.nabenik.com
```

One of the caveats of using certbot is the dependency of python version. Another alternative if you find any issues is to install it with `pip`

```prettyprint
yum install -y python-pip
pip install certbot-nginx
certbot --nginx -d ocl.nabenik.com
```

If everything works as expected, you should see the Payara page under SSL.

![Payara SSL](/images/posts/reversepayara/payarassl.png "Payara SSL")

Finally and most importantly, Let's Encrypt certificates are valid just for 90 days, hence you could add certification renewal (`crontab -e`) as a cron task

    15 3 * * * /usr/bin/certbot renew --quiet


