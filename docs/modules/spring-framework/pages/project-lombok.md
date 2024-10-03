# :clipboard: PROJECT LOMBOK

<p>
  <a href="https://projectlombok.org/features/" rel="noreferrer">
      <img src="https://img.shields.io/badge/Documentation-2088E9?logo=quickLook&logoColor=white" alt="Documentation"/>
  </a>
</p>

Project Lombok **saves your time** and gives you **cleaner code**. It provides **annotations** which help to eliminate writing :star: **ceremonial code** :star: e.g. getters and setters.

Why "Lombok"? "Java" is also an island in Indonesia. "Lombok" is the **second island** east of the island "Java". "Lombok" is also Indonesian for **chilli**.

Lombok **hooks in** via the **annotation processor API**. The **raw source code** is passed to Lombok for **code generation** before Java compilation continues. Code is **generated** and **compiled**, there is **no runtime performance penalty**.

## :pushpin: Dependency

```xml
<dependencies>
  <dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <optional>true</optional>
  </dependency>
</dependencies>
<build>
  <plugins>
    <plugin>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-maven-plugin</artifactId>
      <configuration>
        <excludes>
          <exclude>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
          </exclude>
        </excludes>
      </configuration>
    </plugin>
  </plugins>
</build>
```

## :pushpin: Requirements

* [Lombok](https://plugins.jetbrains.com/plugin/6317-lombok) IDE plugin
* Enable annotation processing (in IntelliJ IDEA go to `Settings` -> `Build, Execution, Deployment` -> `Compiler` -> `Annotation Processors`)

## :pushpin: Delombok

Delombok converts **Lombok annotations** to **code** in **source class**.

In IntelliJ IDEA delombok is available in top menu under: `Refactor` -> `Delombok`.

## :pushpin: Annotations

* `lombok.Data` - equivalent to `@Getter`, `@Setter`, `@RequiredArgsConstructor`, `@ToString` and `@EqualsAndHashCode`
* `lombok.Value` - immutable variant of `@Data`. Equivalent to `@Getter` `@FieldDefaults(makeFinal=true, level=AccessLevel.PRIVATE)` `@AllArgsConstructor` `@ToString` and `@EqualsAndHashCode`
* `lombok.Builder` - generates Builder design pattern for object creation
* `lombok.experimental.FieldDefaults` - adds modifiers to each field in the type with this annotation
* `lombok.Getter` - generates getter
* `lombok.Setter` - generates setter
* `lombok.NoArgsConstructor` - generates a constructor without arguments
* `lombok.RequiredArgsConstructor` - generates a constructor with required arguments (the ones marked with `final` or `@NonNull`)
* `lombok.AllArgsConstructor` - generates a constructor will all arguments
* `lombok.ToString` - generates an implementation for the `java.lang.Object#toString` method inherited by all objects, consisting of printing the values of relevant fields
* `lombok.EqualsAndHashCode` - generates implementations for the `java.lang.Object#equals` and `java.lang.Object#hashCode` methods inherited by all objects, based on relevant fields.
* `lombok.NonNull` - generates a null-check, which can throw `java.lang.NullPointerException`
* `lombok.SneakyThrows` - throws checked exceptions without actually declaring this in your method's `throws` clause. It simply fakes out the compiler: Useful for:
  * An "impossible" exception - the one which will never occur
  * A needlessly strict interface
* `lombok.Synchronized` - a safer variant of `synchronized` method modifier. It will synchronize on a private internal Object named `$lock` instead of `this`. Locking on `this` or your own class object can have unfortunate side-effects, as other code not under your control can lock on these objects as well, which can cause race conditions and other nasty threading-related bugs.
* `lombok.Locked` - like `@Synchronized`, but using `java.util.concurrent.locks.ReentrantLock`. It is recommended for Virtual Threads (introduced in Java 20)
* `lombok.extern.java.Log` - generates a `log` field of type `java.util.logging.Logger` which is awful
* `lombok.extern.slf4j.Slf4j` - generates a `log` field of type [org.slf4j.Logger](https://www.slf4j.org/manual.html)

Local variables:
* `lombok.val` - declares **final** local variable
* `lombok.var` - declares **mutable** (not final) local variable
