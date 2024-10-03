# :clipboard: JsonPath

<p>
    <a href="https://github.com/json-path/JsonPath" rel="noreferrer">
        <img src="https://img.shields.io/badge/Documentation-2088E9?logo=quickLook&logoColor=white" alt="Documentation"/>
    </a>
</p>

A Java DSL (Domain Specific Language) for reading JSON documents. It is included in Spring Boot Test dependency. Useful for performing assertions against the JSON object that is coming back from MockMvc.

JsonPath expressions can use the dot–notation:

`$.store.book[0].title`

or the bracket–notation:

`$['store']['book'][0]['title']`

See the Documentation for more information.
