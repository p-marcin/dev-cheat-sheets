# :clipboard: MAPSTRUCT

<p>
  <a href="https://mapstruct.org/documentation/reference-guide/" rel="noreferrer">
      <img src="https://img.shields.io/badge/Documentation-2088E9?logo=quickLook&logoColor=white" alt="Documentation"/>
  </a>
</p>

MapStruct is a code generator which automates generation of type converters. It works like Project Lombok via annotation processing during code compilation. It is useful for creating Type Converters which can convert Data Transfer Object into Database Entity and Database Entity into Data Transfer Object.

## :pushpin: Dependency

```xml
<dependencies>
  <dependency>
    <groupId>org.mapstruct</groupId>
    <artifactId>mapstruct</artifactId>
    <version>${org.mapstruct.version}</version>
    <optional>true</optional>
  </dependency>
</dependencies>
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <configuration>
          <annotationProcessorPaths>
            <path>
              <groupId>org.mapstruct</groupId>
              <artifactId>mapstruct-processor</artifactId>
              <version>${org.mapstruct.version}</version>
            </path>
            <path>
              <groupId>org.projectlombok</groupId>
              <artifactId>lombok</artifactId>
              <version>${lombok.version}</version>
            </path>
            <path>
              <groupId>org.projectlombok</groupId>
              <artifactId>lombok-mapstruct-binding</artifactId>
              <version>0.2.0</version>
            </path>
          </annotationProcessorPaths>
          <compilerArgs>
            <compilerArg>-Amapstruct.defaultComponentModel=spring</compilerArg>
          </compilerArgs>
        </configuration>
    </plugin>
  </plugins>
</build>
```

## :pushpin: Mapper annotation

* `@org.mapstruct.Mapper` - marks an interface or abstract class as a Mapper and activates the **generation** of a implementation of that type via MapStruct:
    ```java
    @org.mapstruct.Mapper
    public interface CustomerMapper {
    
        Customer customerDtoToCustomer(CustomerDTO customerDTO);
    
        CustomerDTO customerToCustomerDto(Customer customer);
    
    }
    ```
