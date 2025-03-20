# :clipboard: API

Legend:
* :green_circle: - class
* :orange_circle: - abstract class
* :white_circle: - interface

## :pushpin: Spring Core

* :white_circle: `org.springframework.context.ApplicationContext` - central interface to provide configuration for an application
    * You can use `getBean` method to get the bean instance that uniquely matches the given object type, if any

## :pushpin: Spring Boot

* :green_circle: `org.springframework.boot.SpringApplication` - class that can be used to bootstrap and launch a Spring application from a Java main method
* :white_circle: `org.springframework.boot.CommandLineRunner` - indicates that a bean should **run** every time that Spring Boot starts up

## :pushpin: Spring Web

* :white_circle: `org.springframework.ui.Model` - defines a holder for model attributes
* :green_circle: `org.springframework.http.HttpHeaders` - a data structure representing HTTP request or response headers
* :green_circle: `org.springframework.http.ResponseEntity` - extension of `HttpEntity` that adds an `HttpStatusCode` status code. Used in `RestTemplate` as well as in `@Controller` methods
* :green_circle: `org.springframework.http.MediaType` - adds support for Media Types used in `Content-Type` and `Accept` HTTP headers
* :green_circle: `com.fasterxml.jackson.databind.ObjectMapper` - provides functionality for reading and writing JSON, either to and from basic POJOs, or to and from a general-purpose JSON Tree Model, as well as related functionality for performing conversions. It is managed by Spring Context, so it can be `@Autowired`
  * `writeValueAsString` - useful for creating JSON from basic POJO
* :green_circle: `org.springframework.web.servlet.mvc.support.DefaultHandlerExceptionResolver` - resolves standard Spring MVC exceptions and translates them to corresponding HTTP status codes
* :green_circle: `org.springframework.boot.autoconfigure.web.servlet.error.BasicErrorController` - global error controller. It can be extended for additional error response customization
* :green_circle: `org.springframework.web.server.ResponseStatusException` - exception which allows setting the HTTP status and message in constructor

## :pushpin: Spring Data JPA

* :white_circle: `org.springframework.data.repository.CrudRepository<T, ID>` - defines generic CRUD operations on a repository for a specific type
* :white_circle: `org.springframework.data.jpa.repository.JpaRepository<T, ID>` - provides additional methods related to JPA: e.g. `flush` or `deleteAllInBatch` and also paging and sorting
* :white_circle: `org.springframework.data.domain.Page<T>` - a sublist of a list of objects. It allows gain information about the position of it in the containing entire list
* :green_circle: `org.springframework.data.domain.PageRequest` - basic Java Bean implementation of :white_circle: `org.springframework.data.domain.Pageable` used for pagination information
* :green_circle: `org.springframework.data.domain.Sort` - sort option for queries
