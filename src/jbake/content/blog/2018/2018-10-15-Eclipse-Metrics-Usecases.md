title=Eclipse MicroProfile Metrics, practical use cases
date=2018-10-17
type=post
tags=java
status=draft
~~~~~~

## Background

At the end of 2000 decade, one of the main motivations for DevOps creation was the (relatively speaking) neglected interaction between development, QA and operations teams.

In this line, **the "DevOps promise" could be summarized as the union between culture, practices and tools** to improve software quality and, at the same time, to speed up software development teams in terms of time to market. Winning in many successful implementations colateral effects like scalability, stability, security and development speed.

In line with diverse opinions, to implement a successful DevOps culture IT teams need to implement practices like:

* Continuos integration (CI)
* Continuos delivery (CD)
* MicroServices
* Infrastructure as code
* Communication and collaboration
* **Monitoring and metrics**

In this world of **buzzwords** it's indeed difficult to identify the DevOps maturity state without losing the final goal: **To create applications that generate value for the customer in short periods of time**.

In this post, we will discuss about monitoring and metrics in the Java Enterprise World, specially how the new DevOps practices impact the architectural decision at the technology selection phase.

## Metrics in Java monoliths

If traditional architectures are considered, monolithic applications hold common characteristics like:

1. Execution over servlet containers and application servers, with the JVM being a **long running** process.
2. Ideally, these containers are never rebooted, or reboots are allowed on planned maintenance Windows.
3. An application could compromise the integrity of the entire monolith under several conditions like bad code, bad deployments and server issues.

**Without considering any Java framework, the deployment structure will be similar to the figure**. In here we observe that applications are distributed by using .war or .jar files, being collected in .ear files for management purposes. In these architectures applications are created as modules, and separated considering its business objectives.

![Monolith deployment](/images/posts/metrics/monolith.png)

If a need to scale appears, there are basically two options, 1- to scale server resources (vertical) and 2- to add more servers with an application copy to distribute clients using a load balancer. It is worth to notice that new nodes tend to be also **long running** processes, since any application server reboot implies a considerable amount of time that is directly proportional to the quantity of applications that have been deployed.

Hence, the decision to provision (or not) a new application server often is a combined decision between development and operations teams, and with this you have the following options to monitor the state of your applications and application server:

1. Vendor or vendor-neutral telemetric APIs -e.g  [Jookla](https://jolokia.org/), [Glassfish REST Metrics](https://www.oracle.com/technetwork/articles/java/glassfishmm-2082439.html)-
2. JMX monitoring through specific tools and ports -e.g. [VisualVM](https://visualvm.github.io/), [Mission Control](https://github.com/JDKMissionControl/jmc)-
3. "Shell wrangling" with tail, sed, cat, top and htop

It should be noticed also, in this kind of deployments it's necessary to obtain metrics from **application and server**, creating a complex scenario for status monitoring.

The *rule of thumb* for this scenarios is often to choose telemetric/own APIs to monitor application state and JMX/Logs for a deeper analysis of runtime situation, again presenting more questions:

* Which telemetric API should I choose? Do I need a specific format?
* Server's telemetry would be sufficient? How metrics will be processed?
* How do I got access to JMX in my deployments if I'm a Containers/PaaS user?

## Reactive applications

**One of the (not so) recent approaches to improve users experience is to implement reactive systems** with the defined principles of the [Reactive Manifesto](https://www.reactivemanifesto.org/).

![Reactive manifesto](/images/posts/metrics/reactive-traits.png)

In short, a reactive system is a system capable of:

* Being directed/activated by messages often processed asynchronously
* Presents resilience by failing partially, without compromising all the system
* Is elastic to provision and halt modules and resources on demand, having a direct impact in resources billing
* The final result is a responsive system for the user

Despite not being discussed so often, **reactive architectures have a direct impact on metrics**. With dynamic provisioning you won't have long running processes to attach and save metrics, and additionally the services are switching ip addresses depending on clients demand.

## Metrics in Java Microservices architectures

Without considering any particular framework or library, the reactive architectural style puts as **strong suggestion** the deployments of containers and/or Microservice, specially for resilience and elasticity:

![Microservices deployment](/images/posts/metrics/microservices.png)

In a traditional Microservices architecture we observe that services are basically short-lived "workers", which could have clones reacting to changes on clients demands. These kind of environments are often orchestrated with tools like Docker Swarm or Kubernetes, hence each service is responsable of register themself to a service registry acting as a directory, the ideal source for any metric tool to read services location, **pulling and saving the correspondent metrics**.

## Metrics with Java EE and Eclipse MicroProfile

Despite the early efforts on the EE space like [an administrative API with metrics](https://jcp.org/en/jsr/detail?id=77), the need of a formal standard for metrics became mandatory due Microservices popularization. Being **[Dropwizard Metrics](https://metrics.dropwizard.io/3.1.0/) one of the pioneers to cover the need of a telemetric toolkit with [specific CDI extensions](https://github.com/astefanutti/metrics-cdi).

In this line, the MicroProfile project has included among its recent versions(1.4 and 2.0) support for Healthcheck and state metrics. **Many of the actual DropWizard users would notice that annotations are similar if not the same. In fact Microprofile annotations are based directly on DropWizard's [API 3.2.3](https://microprofile.io/project/eclipse/microprofile-metrics/spec/src/main/asciidoc/app-programming-model.adoc)**.

Healthcheck is in charge of answering a simple question "Is the service running and how well is it doing it?", and Metrics present instant or periodical metrics on services.

Last version of MicroProfile (2.0) includes support for Metrics 1.1, including:

* Counted
* Gauge
* Timed
* Histogram

So, it is worth to **give these a try with practical use cases**.

## Metrics with Payara and Eclipse MicroProfile

For the test we will use an application composed by two microservices, as described in the diagram:

![Arquitectura tests](/images/posts/metrics/demomicro.png)

**Our scenario includes two microservices, OmdbService focused on information retrieving from OMDB to obtain up to date movie information and MovieService aimed to obtain movie information from a relational database and mix it with OMDB plot**. Projects code is available at GitHub.

To activate support for MicroProfile 2.0 two things are needed, 1- the right dependency on pom.xml and 2- to deploy/run our application over a MicroProfile compatible implementation, like Payara Micro.

```xml
<dependency>
	<groupId>org.eclipse.microprofile</groupId>
	<artifactId>microprofile</artifactId>
	<type>pom</type>
	<version>2.0.1</version>
	<scope>provided</scope>
</dependency>
```

MicroProfile uses a basic convention in regards of metrics, presenting three levels:

1. **Base:** Mandatory Metrics for all MicroProfile implementations, located at `/metrics/base`
2. **Application:** Custom metrics are exposed by the developer, located at `/metrics/application`
3. **Vendor:** Any MicroProfile implementation could implement its own, located at `/metrics/vendor`

Depending on requests header, metrics will be available in JSON or [OpenMetrics](https://openmetrics.io/) format. The last one popularized as the forma of choice for Prometheus, a [Cloud Native Computing Foundation project](https://www.cncf.io/announcement/2018/08/09/prometheus-graduates/).

## Practical use cases

So far, we've established that:

1. You could monitor your Java application by using telemetric APIs and JMX
2. Reactive applications present new challenges, specially due microservices dynamic and short running nature
3. JMX is sometimes difficult to implement on container/PaaS based deployments
4. MicroProfile Metrics is a new proposal for Java(Jakarta) EE environments, working indistinctly for monoliths and microservices architectures

In this post we present a couple of cases, to be discussed at Oracle Code One ([do not miss our presentation](https://oracle.rainfocus.com/widget/oracle/oow18/catalogcodeone18?search=Orozco)).


### Caso 1: Telemetría para servidores monolíticas
Uno de los puntos más interesantes de Eclipse MicroProfile es que en si misma son extensiones de Java EE, por lo que es posible utilizar las métricas proveídas en entornos tradicionales. Por ejemplo si desplegamos unicamente el servicio de OMDB sobre Payara 5, este sera el resultado al consultar las métricas Base en el servidor de aplicaciones (`http://localhost:8080/metrics`).


![Base metrics](/images/posts/metrics/base-metrics.png)

Para probar la funcionalidad Base de MicroProfile, ejecutaremos peticiones http hacia

`http://localhost:8080/omdb-demo/rest/omdb/tt0133093`

Mediante la cual obtendremos la información de Matrix, esta API ha sido programada con un cliente JAX-RS de tipo blocking para forzar la creación de nuevos threads al momento de realizar la consulta.

![Matrix](/images/posts/metrics/matrix.png)


Simulando una carga hacia la aplicación mediante JMeter durante 15 minutos de prueba podemos observar que las métricas presentadas vía JMX son bastante cercanas a las presentadas por Metrics. Con lo cual consideraremos que Metrics sera una alternativa viable para casos que no involucren profiling a bajo nivel. **El único inconveniente "real" al utilizar Prometheus es la necesidad de crear nuestras propias consultas**.



### Caso 2: Reemplazando a JMX en MicroServicios


### Caso 3: Identificando cuellos de botella en aplicaciones


### Caso 4: Identificando cuellos de botella en aplicaciones
