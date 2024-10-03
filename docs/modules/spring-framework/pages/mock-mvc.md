# :clipboard: MOCK MVC

<p>
    <a href="https://docs.spring.io/spring-framework/reference/testing/spring-mvc-test-framework.html" rel="noreferrer">
        <img src="https://img.shields.io/badge/MockMvc%20Documentation-2088E9?logo=quickLook&logoColor=white" alt="MockMvc Documentation"/>
    </a>
    <a href="https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html" rel="noreferrer">
        <img src="https://img.shields.io/badge/Mockito%20Documentation-2088E9?logo=quickLook&logoColor=white" alt="Mockito Documentation"/>
    </a>
</p>

## :pushpin: Annotations

* `org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest` - annotation that can be used for a Spring MVC test that focuses **only** on Spring MVC components. Pass Controller class as value to limit the test scope
* `org.springframework.boot.test.mock.mockito.MockBean` - add mocks to a Spring ApplicationContext
* `org.mockito.Captor` - allows shorthand ArgumentCaptor creation on fields

## :pushpin: API

* :green_circle: `org.springframework.test.web.servlet.MockMvc` - main entry point for server-side Spring MVC test support
* :orange_circle: `org.springframework.test.web.servlet.request.MockMvcRequestBuilders` - static factory methods for building request
* :orange_circle: `org.springframework.test.web.servlet.result.MockMvcResultMatchers` - static factory methods for matching the result of an executed request against some expectation. It uses [JsonPath](json-path.md) expressions when evaluating JSON response.
* :green_circle: `org.mockito.BDDMockito` - enables mock creation, verification and stubbing. Uses Behavior Driven Development style of writing tests (`given`, `when`, `then`)
* :green_circle: `org.mockito.ArgumentMatchers` - allows flexible verification or stubbing
* :green_circle: `org.mockito.ArgumentCaptor<T>`- allows to capture method argument values for further assertions
* :green_circle: `org.hamcrest.core.Is` - decorates another Matcher, retaining the behaviour but allowing tests to be slightly more expressive

Legend:
* :green_circle: - class
* :orange_circle: - abstract class
* :white_circle: - interface
