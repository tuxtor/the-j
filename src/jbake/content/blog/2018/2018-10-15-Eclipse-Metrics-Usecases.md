title=Eclipse MicroProfile Metrics, practical use cases
date=2018-10-17
type=post
tags=java
status=draft
~~~~~~

## Background

At the end of 2000 decade, one of the main motivations for DevOps creation was the (relatively speaking) neglected interaction between development, QA and operations teams.

In this line, **the "DevOps promise" could be resumed as a conjuction between culture, practices and tools** to improve software quality and, at the same time, to speed up software development teams in terms of time to market. Winning in many successful implementations colateral effects like scalability, stability, security and development speed.

In line with divers oppinions, to implement a succesfull DevOps culture, IT teams need to implement practices like:

* Continuos integration (CI)
* Continuos delivery (CD)
* MicroServices
* Infrastructure as code
* Communication and collaboration
* **Monitoring and metrics**

In this world of **buzzwords** it's indeed difficult to identify the DevOps maturity state without losing the final goal: **To create applications that generate value for the customer in short periods of time**.

In this post, we will discuss about monitoring and metrics in the Java Enterprise World, specially how the new DevOps practices impact the architectural decision in the technology selection phase.

## Metrics in Java monoliths

If traditional architectures are considered, monolithic applications hold common characteristics like:

1. Execution over servlet containers and application servers, with the JVM being a **long running** process.
2. Ideally, these containers are never rebooted, or reboots are allowed on planified mantainance Windows.
3. An application could compromise the integrity of the entire platform under several conditions like bad code, bad deployments and server issues.

**Without considering any Java framework, the deployment structure will be simmilar to the figure**. In here we observe that applications are distributed with .war or .jar files, being collected in .ear files for management purposes. In these architectures applications are created and separated considering its business objective.

![Monolith deployment](images/posts/metrics/monolith.png)

If a need to scale appears, there are basically two options -i.e. to scale server resources (vertical) and to add more servers with an application copy to distribute clients using a load balancer-. It is worth to notice that new nodes tend to be also **long running** processes, since any application server reboot implies a considerable amount of time that is directly proportional to the quantity of applications that have been deployed.

Hence, the decision to provision (or not) a new application server often is a combined decission between development and operations teams, and with this you have the following options to monitor the state of your applications and application server:

1. Vendor or vendor-neutral telemetric APIs -e.g  [Jookla](https://jolokia.org/), [Glassfish REST Metrics](https://www.oracle.com/technetwork/articles/java/glassfishmm-2082439.html)-
2. JMX monitorint through specific tools and ports -e.g. [VisualVM](https://visualvm.github.io/), [Mission Control](https://github.com/JDKMissionControl/jmc)-
3. "Shell wrangling" with tail, sed, cat, top and htop

It should be noticed also, in this kind of deployments it's necessary to obtain metrics from **application and server**, creating a complex scenario for status monitoring.

The *rule of thumb* for this scenarios is often to choose telemetric/own APIs to monitor application state and JMX/Logs for a deeper analysis of runtime situation, again presenting more questions:

* Which telemtric API should I choose? Do I need a specific format?
* Server's telemetry is sufficient? How metrics will be processed?
* How do I got access to JMX in my deployments if I'm a Containers/PaaS user?

## Reactive applications

En línea con la búsqueda de generación de valor para el usuario, **uno de los abordajes recientes para mejorar la experiencia es el uso e implementación de sistemas reactivos**, definiendo sus principios en el [Reactive Manifesto](https://www.reactivemanifesto.org/).


![Reactive manifesto](images/posts/metrics/reactive-traits.png)

En esencia un sistema reactivo es una sistema que:

* Reacciona o es dirigido por mensajes (conexiones) de nuevos clientes
* Presenta resiliencia, o sea es capaz de fallar con estilo/parcialmente, sin comprometer todo el sistema
* Es elástico lo que significa que el aprovisionamiento de recursos/copias de la aplicación se realiza de forma dinámica de acuerdo a límites previamente establecidos
* El resultado final, deben ser aplicaciones responsivas para el usuario

A pesar de que no suele discutirse ampliamente, las anteriores consideraciones suelen impactar directamente a las métricas ya que con aprovisionamiento dinámico de instancias no solo se aprovisionan nuevos servidores de forma dinámica, también se eliminan de forma dinámica para reducir costos y como consecuencia: **ya no existen long-running process a los cuales conectarnos con JMX**.

## Métricas en arquitecturas de microservicios con Java
Nuevamente sin importar el framework o incluso el lenguaje de programación. El estilo arquitectural reactivo coloca entre una de sus **sugerencias fuertes** el uso de Microservicios, especialmente para una implementación natural de resiliencia y elasticidad.

La figura a continuación describe una arquitectura tradicional basada en Microservicios:

![Despliegue microservicios](images/posts/metrics/microservices.png)

Observamos que cada uno de los Microservicios no sera más que un "trabajador" sin estado que publica su disponibilidad hacia el registro de servicios. En relación a las métricas, el registro sera el origen de la configuración de un recolector de métricas que posteriormente verifica uno a uno los microservicios activos para un tiempo T y almacena los datos tanto del entorno de ejecución como de la aplicación para proveer visualizaciones en tiempo real.

## Métricas en Java EE y Eclipse MicroProfile

A pesar de que en su momento Java EE tuvo un [API de administración que incluía algunas métricas](https://jcp.org/en/jsr/detail?id=77), la necesidad de un estandar de este tipo se volvió prioridad con la popularización de los microservicios. Siendo **el proyecto [Dropwizard Metrics](https://metrics.dropwizard.io/3.1.0/) uno de los pioneros para suplir la necesidad** de APIs telemétricas para (micro)servicios en Java EE con las extensiones especificas para [CDI](https://github.com/astefanutti/metrics-cdi). 

En línea con estos esfuerzos la iniciativa MicroProfile (extensiones de microservicios para Java EE) ha incluido en sus lanzamientos más recientes (1.4 y 2.0) soporte para metricas de desempeño y estado en las APIs denominadas Healthcheck y Metrics. **Muchos de los usuarios actuales de DropWizard notaran que las anotaciones son similares. De hecho son las mismas ya que MicroProfile ha basado sus anotaciones en la [API 3.2.3 de DropWizard](https://microprofile.io/project/eclipse/microprofile-metrics/spec/src/main/asciidoc/app-programming-model.adoc)**.

Healtcheck básicamente se encarga de responder si el servicio esta o no en ejecución y cual es su estado actual y por otro lado Metrics, las cuales presentan métricas relativas al desempeño de la aplicación


## Métricas con Payara y Eclipse MicroProfile

Para probar la funcionalidad de cada una de las métricas utilizaremos como base una aplicación con dependencia en dos orígenes de datos, descrita en el siguiente diagrama:

![Arquitectura tests](images/posts/metrics/demomicro.png)

**Nuestro escenario de pruebas incluye dos micro servicios, un microservicio denominado OmdbService cuyo único objetivo es conectarse hacia OMDB para obtener información de películas y MovieService cuyo objetivo es obtener la información general de una película desde una base de datos relacional y combinarla con la descripción de OMDB**. El código de ambos proyectos está disponible en GitHub, (MovieService), (OmdbService).


El escenario anterior sera probado sobre Payara 5. Las últimas versiones de Payara incluyen soporte para MicroProfile 2.0 o lo que es lo mismo, soporte para Metrics 1.1 en las cuales se incluye soporte para:

* Counted
* Gauge
* Timed
* Histogram

Para activar el soporte a MicroProfile 2.0 incluiremos la siguiente dependencia en nuestro archivo pom.xml. Notese que el scope seleccionado es `provided` ya que la implementación esta incluida en Payara Micro.


```xml
<dependency>
	<groupId>org.eclipse.microprofile</groupId>
	<artifactId>microprofile</artifactId>
	<type>pom</type>
	<version>2.0.1</version>
	<scope>provided</scope>
</dependency>
```

En MicroProfile, las métricas son expuestas en tres grandes niveles, presentando las siguientes categorías:

1. **Base:** Metricas obligatorias para todos los implementadores. En este nivel cada implementador puede requerir pasos adicionales de configuración, ubicadas en `/metrics/base`
2. **Application:** Las métricas deben ser expuestas por el programador mediante el uso de una API en Java, ubicadas en `/metrics/application`
3. **Vendor:** No existe una implementación única y cada implementador las publica a su conveniencia, ubicadas en `/metrics/vendor`

Dependiendo el encabezado proporcionado al consumir las APIs, las mismas se exponen en formato JSON y [OpenMetrics](https://openmetrics.io/). Este último popularizado por Prometheus, recientemente graduado en [Cloud Native Computing Foundation](https://www.cncf.io/announcement/2018/08/09/prometheus-graduates/).

## Casos prácticos de uso

Hasta este momento hemos establecido que:

1. Existen APIs de telémetria y arquitecturas especificas para monitorizar aplicaciones en Java
2. Las aplicaciones reactivas establecieron nuevas necesidades al medir el estado de aplicaciones en Java
3. JMX suene no ser la mejor opción al momento de monitorizar procesos con tiempos de vida cortos, o entornos de tipo Paas
4. MicroProfile Metrics es una solución para entornos Java EE, sin importar si son arquitecturas tradicionales o basadas en MicroServicios

Plantearemos entonces algunos casos y dejaremos el resto para Oracle Code One ([no se pierdan nuestra presentación](https://oracle.rainfocus.com/widget/oracle/oow18/catalogcodeone18?search=Orozco)).


### Caso 1: Telemetría para servidores monolíticas
Uno de los puntos más interesantes de Eclipse MicroProfile es que en si misma son extensiones de Java EE, por lo que es posible utilizar las métricas proveídas en entornos tradicionales. Por ejemplo si desplegamos unicamente el servicio de OMDB sobre Payara 5, este sera el resultado al consultar las métricas Base en el servidor de aplicaciones (`http://localhost:8080/metrics`).


![Base metrics](images/posts/metrics/base-metrics.png)

Para probar la funcionalidad Base de MicroProfile, ejecutaremos peticiones http hacia

`http://localhost:8080/omdb-demo/rest/omdb/tt0133093`

Mediante la cual obtendremos la información de Matrix, esta API ha sido programada con un cliente JAX-RS de tipo blocking para forzar la creación de nuevos threads al momento de realizar la consulta.

![Matrix](images/posts/metrics/matrix.png)


Simulando una carga hacia la aplicación mediante JMeter durante 15 minutos de prueba podemos observar que las métricas presentadas vía JMX son bastante cercanas a las presentadas por Metrics. Con lo cual consideraremos que Metrics sera una alternativa viable para casos que no involucren profiling a bajo nivel. **El único inconveniente "real" al utilizar Prometheus es la necesidad de crear nuestras propias consultas**.



### Caso 2: Reemplazando a JMX en MicroServicios


### Caso 3: Identificando cuellos de botella en aplicaciones


### Caso 4: Identificando cuellos de botella en aplicaciones
