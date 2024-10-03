# :clipboard: ANNOTATIONS

## :pushpin: Spring Core

* `org.springframework.beans.factory.annotation.Autowired` - marks a constructor, field, setter method, or config method as to be autowired by Spring's dependency injection facilities

## :pushpin: Spring Boot

* `org.springframework.boot.autoconfigure.SpringBootApplication` - indicates a configuration class that declares one or more Bean methods and also triggers auto-configuration and component scanning

## :pushpin: Spring Web

* `org.springframework.stereotype.Component` - indicates that the class is a spring component
* `org.springframework.stereotype.Controller` - indicates that the class is a controller
  * `org.springframework.web.bind.annotation.RequestMapping` - maps web requests onto methods in request-handling classes with flexible method signatures
  * `org.springframework.web.bind.annotation.GetMapping`, `org.springframework.web.bind.annotation.PostMapping`, etc. - equivalent to `@RequestMapping(method = RequestMethod.GET)`, `@RequestMapping(method = RequestMethod.POST)`, etc.
* `org.springframework.web.bind.annotation.RestController` - equivalent to `@Controller` and `@ResponseBody` (indicates a method return value should be bound to the web response body)
  * `org.springframework.web.bind.annotation.PathVariable` - indicates a method parameter should be bound to a URI template variable
  * `org.springframework.web.bind.annotation.RequestParam` - indicates that a method parameter should be bound to a web request parameter
  * `org.springframework.web.bind.annotation.RequestBody` - indicates a method parameter should be bound to the body of the web request
* `org.springframework.web.bind.annotation.ControllerAdvice` - specialization of `@Component` for classes that declare `@ExceptionHandler`, `@InitBinder` or `@ModelAttribute` methods to be shared across multiple `@Controller` classes
* `org.springframework.stereotype.Service` - indicates that the class is a service
* `org.springframework.stereotype.Repository` - indicates that the class is a repository
* `org.springframework.context.annotation.Primary` - indicates that a bean should be given preference when multiple candidates are qualified to autowire a single-valued dependency
* `org.springframework.beans.factory.annotation.Qualifier` - indicates which implementation should be taken when autowiring. Just provide bean name (first letter in lower case) as a value
* `org.springframework.context.annotation.Profile` - if you have two beans named the same, you can switch between them using this annotation (only bean marked with active Profile will be in Application Context)
  * `@Profile({"EN", "default"})` - you can assign more profiles and also set **default** profile (used when there are no active profiles)
* `org.springframework.web.bind.annotation.ExceptionHandler` - allows handling exceptions in specific handler classes and/or handler methods
* `org.springframework.web.bind.annotation.ResponseStatus` - marks a method or exception class with the HTTP status code and reason that should be returned

## :pushpin: Spring Data REST

* `org.springframework.data.rest.core.annotation.RepositoryRestResource` - configure Repository REST settings, e.g. with `(path="resource")` you can set the path of the resource handled by Repository

## :pushpin: Spring Data JPA

* `jakarta.persistence.Entity` - indicates that the class is an entity which will be persisted to the database
* `jakarta.persistence.Id` - indicates the primary key of an entity
* `jakarta.persistence.GeneratedValue` - indicates the generation strategy for primary key. See `jakarta.persistence.GenerationType` enum for generation strategies
  * `@GeneratedValue(strategy = GenerationType.AUTO)` - indicates that primary key generation will be handled by database
* `org.hibernate.annotations.UuidGenerator` - specifies that an entity identifier is generated as a UUID
* `jakarta.persistence.Version` - indicates the version field of an entity that serves as its optimistic lock value
* `jakarta.persistence.Column` - specifies the mapped column for a persistent property or field. If no `@Column` annotation is specified, the default values apply
* `jakarta.persistence.ManyToMany` - indicates a many-valued association with many-to-many multiplicity
  * `@JoinTable(name="author_book", joinColumns = @JoinColumn(name="book_id"), inverseJoinColumns = @JoinColumn(name = "author_id"))` - TODO
* `org.hibernate.annotations.JdbcTypeCode` - specifies the JDBC type-code to use for the column mapping. 
* `org.hibernate.annotations.CreationTimestamp` - specifies that the annotated field of property is a generated creation timestamp. The timestamp is generated just once, when an entity instance is inserted in the database
* `org.hibernate.annotations.UpdateTimestamp` - specifies that the annotated field of property is a generated update timestamp. The timestamp is regenerated every time an entity instance is updated in the database
* `jakarta.persistence.OneToOne` - specifies a single-valued association to another entity that has one-to-one multiplicity
* `jakarta.persistence.OneToMany` - specifies a many-valued association with one-to-many multiplicity
* `jakarta.persistence.ManyToOne` - specifies a single-valued association to another entity class that has many-to-one multiplicity
* `jakarta.persistence.ManyToMany` - specifies a many-valued association with many-to-many multiplicity
* `jakarta.persistence.JoinTable` - specifies the mapping of associations
* `jakarta.persistence.JoinColumn` - specifies a column for joining an entity association or element collection

## :pushpin: Hibernate Validator

* `org.springframework.validation.annotation.Validated` - variant of `jakarta.validation.Valid` supporting the specification of validation groups. Marks a property, method parameter or method return type for validation cascading. This turns on validation constraints checks.
* `jakarta.validation.constraints.Null` - check value is null
* `jakarta.validation.constraints.NotNull` - check value is not null
* `jakarta.validation.constraints.AssertTrue` - checks value is true
* `jakarta.validation.constraints.AssertFalse` - checks value is false
* `jakarta.validation.constraints.Min` - checks number is equal or higher
* `jakarta.validation.constraints.Max` - checks number is equal or less
* `jakarta.validation.constraints.DecimalMin` - checks decimal is equal or higher
* `jakarta.validation.constraints.DecimalMax` - checks decimal is equal or less
* `jakarta.validation.constraints.Negative` - checks number is less than zero. Zero invalid
* `jakarta.validation.constraints.NegativeOrZero` - checks number is zero or less than zero
* `jakarta.validation.constraints.Positive` - checks number is greater than zero. Zero invalid
* `jakarta.validation.constraints.PositiveOrZero` - checks number is zero or greater than zero
* `jakarta.validation.constraints.Size` - checks if string or collection is between a min and max
* `jakarta.validation.constraints.Digits` - checks for integer digits and fraction digits
* `jakarta.validation.constraints.Past` - checks if date is in past
* `jakarta.validation.constraints.PastOrPresent` - checks if date is in past or present
* `jakarta.validation.constraints.Future` - checks if date is in future
* `jakarta.validation.constraints.FutureOrPresent` - checks if date is in future or present
* `jakarta.validation.constraints.Pattern` - checks against RegEx pattern
* `jakarta.validation.constraints.NotEmpty` - checks if value is not null or empty (whitespace characters or empty collection)
* `jakarta.validation.constraints.NotBlank` - checks string is not null or not whitespace characters
* `jakarta.validation.constraints.Email` - checks if string value is an e-mail address
* `org.hibernate.validator.constraints.ScriptAssert` - class level annotation, checks class against script
* `org.hibernate.validator.constraints.CreditCardNumber` - checks value is credit card number
* `org.hibernate.validator.constraints.Currency` - checks if currency is valid
* `org.hibernate.validator.constraints.time.DurationMin` - checks duration greater than given value
* `org.hibernate.validator.constraints.time.DurationMax` - checks duration less than given value
* `org.hibernate.validator.constraints.EAN` - checks if EAN barcode is valid
* `org.hibernate.validator.constraints.ISBN` - checks if ISBN is valid
* `org.hibernate.validator.constraints.Length` - checks string length between given min and max
* `org.hibernate.validator.constraints.CodePointLenght` - checks that code point length of the annotated character sequence is between min and max included
* `org.hibernate.validator.constraints.LuhnCheck` - checks Luhn check sum
* `org.hibernate.validator.constraints.Mod10Check` - checks mod 10 check sum
* `org.hibernate.validator.constraints.Mod11Check` - checks mod 11 check sum
* `org.hibernate.validator.constraints.Range` - checks if number is between given min and max (inclusive)
* `org.hibernate.validator.constraints.UniqueElements` - checks if collection has unique elements
* `org.hibernate.validator.constraints.URL` - checks for valid URL
* `org.hibernate.validator.constraints.pl.NIP` - checks Polish VAR ID
* `org.hibernate.validator.constraints.pl.PESEL` - checks Polish National Validation Number
* `org.hibernate.validator.constraints.pl.REGON` - checks Polish Taxpayer ID

## :pushpin: Spring Test

* `org.springframework.boot.test.context.SpringBootTest` - annotation that can be specified on a test class that runs Spring Boot based tests. It provides **Spring Test Context**
* `org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest` - annotation for a JPA test that focuses only on JPA components
* `org.springframework.context.annotation.Import` - indicates one or more component classes to import
* `org.springframework.test.context.ActiveProfiles` - indicates which active bean definition profiles should be used when loading an Application Context for test classes
* `org.springframework.transaction.annotation.Transactional` - describes a transaction attribute on an individual method or on a class
* `org.springframework.test.annotation.Rollback` - indicates whether a test-managed transaction should be rolled back after the test method has completed
