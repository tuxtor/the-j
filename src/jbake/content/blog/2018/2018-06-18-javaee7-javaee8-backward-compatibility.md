title=Testing JavaEE backward and forward compatibility with Servlet, JAX-RS, Batch and Microprofile
date=2018-06-18
type=post
tags=java
status=published
~~~~~~

One of the most interesting concepts that made Java EE (and Java) appealing for the enterprise is its **great backward compatibility**, ensuring that years of investment in R&D could be reused in future developments.

Neverthless one of the least understood facts is that **Java EE in the end is a set of curated APIs that could be extendend and improved** with additional EE-based APIs -e.g Microprofile, DeltaSpike- and vendor-specific improvements -e.g. Hazelcast on Payara, Infinispan on Wildfly-.

In this article I'll try to elaborate a reponse for a recent question in my development team:

> Is it possible to implement a new artifact that uses Microprofile API within Java EE 7? May I use this artifact also in a Java EE 8 Server?

To answer this question, I prepared a **POC to demonstrate Java EE capabilities**.

## Is Java EE backward compatible? Is it safe to assume a clean migration from EE 7 to EE 8?

One of the most pervasive rules in IT is "if ain't broke, don't fix it", however the **broke is pretty relative in regards of security, bugs and features**.

Commonly, **security vunlerabilities and regular bugs are patched through vendor specific updates in Java EE**, retaining the feature compatibility through EE API level, hence this kind of updates are considered safer and should be applied proactively.

However, once a new EE versión is on the streets, **each vendor publish it's product calendar**, being responsable of the future updates and it's expected that any Java EE user will update his stack (or perish :) ).

In this line Java EE has a complete set of [requrimentes and backward compatibility instructions, for vendors, spec leads and contributors](https://javaee.github.io/javaee-spec/CompatibilityRequirements), this is specially important considering that we receive on every version of Java EE:

* New APIs (like Batch in EE 7 or JSON-B in EE 8)
* APIs that simply don't change and are included in the next EE versión (like Batch in EE 8)
* APIs with minor updates (Bean Validation in EE 8)
* APIS with new features and interfaces (reactive client in JAX-RS EE 8)

According to compatibility requirements, if your code retains and implements only EE standard code you receive source-code compatibility, binary compatibility and behaviour compatibility for any application that uses a previous version of the specificiation, at least that's the idea.

## Creating a "complex" implementation

To test this assumption I've prepared a POC that implements

* Servlets (updated in EE 8)
* JAX-RS (updated in EE 8)
* JPA (minor update in EE 8)
* Batch (does not change in EE 8)
* Microprofile Config (extension)
* DeltaSpike Data (extension)

![Batch Structure](/images/posts/batch/batchee-diagram.png "Components Structure")



This application just **loads a bunch of IMDB records [from a csv file](https://raw.githubusercontent.com/KarthikMaharajan/Data-Mining-on-IMDB-Dataset/master/imdb.csv) in background to save the records in Derby(Payara 4) and H2(Payara 5)** using the `jdbc/__default` JTA Datasource.

For referece, the complete Maven project of this POC is available [at GitHub](https://github.com/tuxtor/batchee-demo).

### Part 1: File upload

The POC a) implements a multipart servlet that receives files from a plain HTML form,  b) saves the file using Microprofile config to retreive the final destination URL and  c) Calls a Batch Job named `csvJob`:

```prettyprint
@WebServlet(name = "FileUploadServlet", urlPatterns = "/upload")
@MultipartConfig
public class FileUploadServlet extends HttpServlet {
    @Inject
    @ConfigProperty(name = "file.destination", defaultValue = "/tmp/")
    private String destinationPath;

    @Inject
    private Logger logger;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String description = request.getParameter("description");
        Part filePart = request.getPart("file");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();


        //Save using buffered streams to avoid memory consumption
        try(InputStream fin = new BufferedInputStream(filePart.getInputStream());
                OutputStream fout = new BufferedOutputStream(new FileOutputStream(destinationPath.concat(fileName)))){

            byte[] buffer = new byte[1024*100];//100kb per chunk
            int lengthRead;
            while ((lengthRead = fin.read(buffer)) > 0) {
                fout.write(buffer,0,lengthRead);
                fout.flush();
            }

            response.getWriter().write("File written: " + fileName);

            //Fire batch Job after file upload
            JobOperator jobOperator = BatchRuntime.getJobOperator();
            Properties props = new Properties();
            props.setProperty("csvFileName", destinationPath.concat(fileName));
            response.getWriter().write("Batch job " + jobOperator.start("csvJob", props));
            logger.log(Level.WARNING, "Firing csv bulk load job - " + description );

        }catch (IOException ex){
            logger.log(Level.SEVERE, ex.toString());

            response.getWriter().write("The error");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }


    }

}
```

You also need a plain HTML form

```prettyprint
<h1>CSV Batchee Demo</h1>
<form action="upload" method="post" enctype="multipart/form-data">
    <div class="form-group">
        <label for="description">Description</label>
        <input type="text" id="description" name="description" />
    </div>
    <div class="form-group">
        <label for="file">File</label>
        <input type="file" name="file" id="file"/>
    </div>

    <button type="submit" class="btn btn-default">Submit</button>
</form>
```

### Part 2: Batch Job, JTA and JPA

[As described in Java EE tutorial](https://javaee.github.io/tutorial/batch-processing.html), typical batch Jobs are composed by steps, these steps also implement a three phase process involving a reader, processor and writer that works by chunks.

Batch Job is defined by using a XML file located in `resources/META-INF/batch-jobs/csvJob.xml`, the reader-writer-processor triad will be implemented through named CDI beans.

```prettyprint
<?xml version="1.0" encoding="UTF-8"?>
<job id="csvJob" xmlns="http://xmlns.jcp.org/xml/ns/javaee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/jobXML_1_0.xsd"
    version="1.0">
    
    <step id="loadAndSave" >
        <chunk item-count="5">
            <reader ref="movieItemReader"/>
            <processor ref="movieItemProcessor"/>
            <writer ref="movieItemWriter"/>
        </chunk>
    </step>
</job>
```

MovieItemReader reads the csv file line per line and wraps the result using a `Movie` object for the next step, note that open, readItem and checkpointInfo methods are overwritten to ensure that the task restarts properly if needed.

```prettyprint
@Named
public class MovieItemReader extends AbstractItemReader {

	@Inject
	private JobContext jobContext;

	@Inject
	private Logger logger;

	private FileInputStream is;
	private BufferedReader br;
	private Long recordNumber;

	@Override
	public void open(Serializable prevCheckpointInfo) throws Exception {
		recordNumber = 1L;
		JobOperator jobOperator = BatchRuntime.getJobOperator();
		Properties jobParameters = jobOperator.getParameters(jobContext.getExecutionId());
		String resourceName = (String) jobParameters.get("csvFileName");
		is = new FileInputStream(resourceName);
		br = new BufferedReader(new InputStreamReader(is));

		if (prevCheckpointInfo != null)
			recordNumber = (Long) prevCheckpointInfo;
		for (int i = 0; i < recordNumber; i++) { // Skip until recordNumber
			br.readLine();
		}
		logger.log(Level.WARNING, "Reading started on record " + recordNumber);
	}

	@Override
	public Object readItem() throws Exception {

		String line = br.readLine();

		if (line != null) {
			String[] movieValues = line.split(",");
			Movie movie = new Movie();
			movie.setName(movieValues[0]);
			movie.setReleaseYear(movieValues[1]);
			
			// Now that we could successfully read, Increment the record number
			recordNumber++;
			return movie;
		}
		return null;
	}

	@Override
	public Serializable checkpointInfo() throws Exception {
	        return recordNumber;
	}
}
```

Since this is a POC my "processing" step just converts the movie title to uppercase and pauses the thread a half second on each row:

```prettyprint
@Named
public class MovieItemProcessor implements ItemProcessor {

  @Inject
  private JobContext jobContext;

	@Override
  public Object processItem(Object obj) 
          throws Exception {
      Movie inputRecord =
              (Movie) obj;
      
      //"Complex processing"
      inputRecord.setName(inputRecord.getName().toUpperCase());
      Thread.sleep(500);
        
      return inputRecord;
  } 
}
```
Finally each chunk is written on MovieItemWriter using a DeltaSpike repository:


```prettyprint
@Named
public class MovieItemWriter extends AbstractItemWriter {

	@Inject
    MovieRepository movieService;
	
	@Inject
	Logger logger;

    public void writeItems(List list) throws Exception {
        for (Object obj : list) {
        	logger.log(Level.INFO, "Writing " + obj);
            movieService.save((Movie)obj);
        }
    }
}
```

For reference, this is the Movie Object

```prettyprint
@Entity
@Table(name="movie")
public class Movie implements Serializable {

	@Override
	public String toString() {
		return "Movie [name=" + name + ", releaseYear=" + releaseYear + "]";
	}

	private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    @Column(name="movie_id")
    private int id;
    
    @Column(name="name")
    private String name;
    
    @Column(name="release_year")
    private String releaseYear;

    //Getters and setters
```

Default datasource is configured on `resources/META-INF/persistence.xml`, note that I'm using a JTA Data Source:

```prettyprint
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<persistence xmlns="http://xmlns.jcp.org/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/persistence http://xmlns.jcp.org/xml/ns/persistence/persistence_2_1.xsd"
             version="2.1">

    <persistence-unit name="batchee-persistence-unit" transaction-type="JTA">
        <description>BatchEE Persistence Unit</description>
        <jta-data-source>jdbc/__default</jta-data-source>
        <exclude-unlisted-classes>false</exclude-unlisted-classes>
		 <properties>
		      <property name="javax.persistence.schema-generation.database.action" value="drop-and-create"/>
		      <property name="javax.persistence.schema-generation.scripts.action" value="drop-and-create"/>
		      <property name="javax.persistence.schema-generation.scripts.create-target" value="sampleCreate.ddl"/>
		      <property name="javax.persistence.schema-generation.scripts.drop-target" value="sampleDrop.ddl"/>
		    </properties>
    </persistence-unit>
</persistence>
```

To test JSON marshalling throug JAX-RS I also implemented a Movie endpoint with GET method, the repository (AKA DAO) is defined by using DeltaSpike

```prettyprint
@Path("/movies")
@Produces({ "application/xml", "application/json" })
@Consumes({ "application/xml", "application/json" })
public class MovieEndpoint {
	
	@Inject
	MovieRepository movieService;

	@GET
	public List<Movie> listAll(@QueryParam("start") final Integer startPosition,
			@QueryParam("max") final Integer maxResult) {
		final List<Movie> movies = movieService.findAll();
		return movies;
	}

}
```
The repository

```prettyprint
@Repository(forEntity = Movie.class)
public abstract class MovieRepository extends AbstractEntityRepository<Movie, Long> {
	
	@Inject
    public EntityManager em;
}

```

## Test 1: Java EE 7 server with Java EE 7 pom
Since the objective is to test real backward (lower EE level than server) and forward (Micprofile and DeltaSpike extensions) compatibility, first I built and deployed this project with the following dependencies on `pom.xml`, the EE 7 Pom vs EE 7 Server  test is only executed to verify that project works properly: 


```prettyprint
<dependencies>
        <dependency>
            <groupId>javax</groupId>
            <artifactId>javaee-api</artifactId>
            <version>7.0</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>org.eclipse.microprofile</groupId>
            <artifactId>microprofile</artifactId>
            <version>1.3</version>
            <type>pom</type>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.deltaspike.modules</groupId>
            <artifactId>deltaspike-data-module-api</artifactId>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.deltaspike.modules</groupId>
            <artifactId>deltaspike-data-module-impl</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.deltaspike.core</groupId>
            <artifactId>deltaspike-core-api</artifactId>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.deltaspike.core</groupId>
            <artifactId>deltaspike-core-impl</artifactId>
            <scope>runtime</scope>
        </dependency>
    </dependencies>
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.apache.deltaspike.distribution</groupId>
                <artifactId>distributions-bom</artifactId>
                <version>${deltaspike.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
    <build>
        <finalName>batchee-demo</finalName>
    </build>
    <properties>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <deltaspike.version>1.8.2</deltaspike.version>
        <failOnMissingWebXml>false</failOnMissingWebXml>
    </properties>
```

As expected, the application loads the data properly, here two screenshots taken during batch Job Execution:

![Payara 4 Demo 1](/images/posts/batch/payara4a.png "Payara 4 Instant 1")

![Payara 4 Demo 2](/images/posts/batch/payara4b.png "Payara 4 Instant 2")

## Test 2: Java EE 8 server with Java EE 7 pom
To test the real binary compatibility, **the application is deployed without changes on Payara 5 (Java EE 8)**, [this Payara release also switches Apache Derby with H2 database](https://docs.payara.fish/documentation/payara-micro/h2/h2.html). 

As expected and according with Java EE compatibility guidelines, the application works flawesly.


![Payara 5 Demo 1](/images/posts/batch/payara5a.png "Payara 5 Instant 1")

![Payara 5 Demo 2](/images/posts/batch/payara5b.png "Payara 5 Instant 2")


To verify assumptions, this is a query launched through SQuirrel SQL:
![SQuirrel SQL Demo](/images/posts/batch/squirel.png "SQuirrel SQL")


## Test 3: Java EE 8 server with Java EE 8 pom
Finally to enable new EE APIs, a little bit of tweaking is needed on pom.xml, specifically the JavaEE dependency

```prettyprint
<dependency>
    <groupId>javax</groupId>
    <artifactId>javaee-api</artifactId>
    <version>8.0</version>
    <scope>provided</scope>
</dependency>
```
Again, the application just works:

![Payara 5 Java EE 8](/images/posts/batch/payara5ee8.png "Payara 5 Java EE 8 pom")

This is why standards matters :).