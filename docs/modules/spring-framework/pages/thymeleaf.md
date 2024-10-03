# :clipboard: THYMELEAF

<p>
  <a href="https://www.thymeleaf.org/documentation.html" rel="noreferrer">
      <img src="https://img.shields.io/badge/Documentation-2088E9?logo=quickLook&logoColor=white" alt="Documentation"/>
  </a>
</p>

## :pushpin: Dependency

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```

## :pushpin: Namespace

```html
<html lang="en" xmlns:th="https://www.thymeleaf.org">
```

## :pushpin: Iteration

You can iterate on **any arrays** and **any objects implementing**:
* `java.util.Iterable` - e.g. `java.util.List`
* `java.util.Map` - in this case iteration variables will be of class `java.util.Map.Entry`
* and so on.

```html
<table>
    <tr th:each="book : ${books}">
        <td th:text="${book.id}"></td>
        <td th:text="${book.title}"></td>
        <td th:text="${book.publisher.name}"></td>
    </tr>
</table>
```
