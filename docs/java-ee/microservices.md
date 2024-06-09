# :clipboard: MICROSERVICES

<!-- TOC -->
* [:pushpin: Architectures: Monolithic vs SOA vs Microservice](#pushpin-architectures-monolithic-vs-soa-vs-microservice)
* [:pushpin: Microservices](#pushpin-microservices)
* [:pushpin: Costs to pay for moving to Microservice Architecture](#pushpin-costs-to-pay-for-moving-to-microservice-architecture)
* [:pushpin: Service Design](#pushpin-service-design)
* [:pushpin: The API layer](#pushpin-the-api-layer)
* [:pushpin: Edge Services](#pushpin-edge-services)
* [:pushpin: Cloud-Native](#pushpin-cloud-native)
* [:pushpin: Scalability](#pushpin-scalability)
* [:pushpin: Gridlock situations](#pushpin-gridlock-situations)
* [:pushpin: Communication Models: Synchronous vs Asynchronous](#pushpin-communication-models-synchronous-vs-asynchronous)
* [:pushpin: Database Transaction Models: ACID vs BASE](#pushpin-database-transaction-models-acid-vs-base)
* [:pushpin: Logging and Distributed Tracing](#pushpin-logging-and-distributed-tracing)
* [:pushpin: Embracing DevOps](#pushpin-embracing-devops)
<!-- TOC -->

## :pushpin: Architectures: Monolithic vs SOA vs Microservice

* **Monolithic Architecture** - entire application is constructed as a unified, standalone unit. It is decomposed internally into layers: Presentation, Business Logic and Data Access.
* **SOA (Service Oriented Architecture) also known as Centralized Architecture** - application is constructed with multiple services interacting with a centralized software component (Enterprise Service Bus) to make traditional Monolithic less burden and loosely coupled. These services communicate with one another via SOAP (XML with Envelope usually consisting of Header and Body).
* **Microservice Architecture** - application is constructed with compact, autonomous, and loosely connected services. These services communicate with one another via REST. It is type of Distributed System.

## :pushpin: Microservices

* Microservices are about decomposing the system into more discrete units of work. **Decomposition** is breaking software problem into smaller pieces that are easier to understand and solve.
* Microservices embrace the concept of **Protocol-Aware Heterogeneous Interoperability** to handle all communication:
  * **Protocol-Aware** means that every call within the service boundaries are solved via REST over HTTP.
  * **Heterogeneous Interoperability** means that we can integrate with services implemented in different programming languages.
* In a pure Microservice Architecture each unit of work can be **called** from any other unit of work within the system.
* While smaller artifacts make development easier, deployments can become a nightmare. **Continuous Delivery** model should be built early in the process.

## :pushpin: Costs to pay for moving to Microservice Architecture

* **Complexity** - it will dramatically cost you time and money as you move from a few deployed artifacts to many. In addition to the deployment complexity, determining where all the code lives and operates can increase the complexity and the costs associated with it.
* **Distribution Tax** - there is a dramatic increase in network communications between the individual services as their number grows. This increases the total latency of calls across the network as a whole. The increase in call volume tends to risk congestion, causing catastrophic latency across the whole network. A single slow call in the stack can cause thread blocking that impacts other client calls.
* **Reduction of Reliability** - as you put more moving parts into a system, there is a decrease in the overall reliability of the system as a whole. It becomes critical to evaluate your most core services and determine if they can withstand system unreliability.

## :pushpin: Service Design

* **Service Design Anti-Patterns**:
  * Too fine-grained.
  * Not fine-grained enough.
* The key to finding the sweet spot on granularity is to leverage **Domain-Driven Design**.
* There is no standard way of documenting RESTful services like there was with WSDL in the SOAP world, so developing common means of **service documentation** is critical especially in large organizations.
* In a Microservices world size isn’t as critical as **operations**. A Microservice handles one set of related functions with little or no cross-domain operations.

## :pushpin: The API layer

* The API layer is a **pure proxy**.
* If you find your API layer is doing **transformations** or **executing logic** you’re doing it wrong.
* The API layer is used to **shield the outside world** or your clients from knowing the structure, organization, or even what exact service is exposing a specific operation.
* A passive API is a passive API - no exceptions. This means we cannot introduce **breaking API changes**. Instead, **versioning** should be leveraged.

## :pushpin: Edge Services

* **Outbound Edge Services** - expose your client's specific needs to the outside world. Not every client that consumes your service needs the same data payload (e.g. PC vs Mobile).
* **Inbound/Translation Edge Services** - abstract you from third party dependencies. You can either call the APIs of the third party directly or build an Edge Service that you own to interact with the third party.

## :pushpin: Cloud-Native

* **Cloud Computing** - pattern of globally distributing systems to provide increased uptime, increased scalability and increased distribution.
* **Cloud Infrastructure** can be:
  * **Public** - delivered via the internet and shared across organizations.
  * **Private** - dedicated solely to your organization.
  * **Hybrid** - any environment that uses both public and private clouds.
* [**The Twelve-Factor App**](https://12factor.net/) principles are a collection of best practices for building Microservices-Based Cloud-Native applications.
* You can build Monolithic Cloud-Native application, and you can build Microservices that are not capable of moving to the cloud at all.

## :pushpin: Scalability

* In a Microservice Architecture, each application is **independent** of every other application in the system. As such, when an individual service comes under load it can be **individually scaled**.
* Traditional strategy of Monolith Architecture is to scale for the **busiest day every day**. In a well-defined Microservice Architecture, you can build your system for an **average day** and **allow scalability** to accommodate increases or decreases in traffic.

## :pushpin: Gridlock situations

* Gridlock can occur when services are under greater load and **latency increases**. While calls are waiting for responses, delays can become unbearable. When this occurs, there can be a **catastrophic failure of the entire system**.
* Gridlock can also occur due to **circular calls** (when a calling service is subsequently called by some downstream service).
* Gridlock can be controlled with:
  * **Circuit Breaker** - a pattern in which a standard flow is built through application, and as latency increases and timeouts begin to occur, the circuit is broken and default behavior is executed. While you may suffer from reduced functionality of your system (e.g. search does not work, but application itself do), it’s often better to do this than to suffer a complete failure.
  * **Strong Timeout Logic** throughout the system.

## :pushpin: Communication Models: Synchronous vs Asynchronous

* One of the best strategies for dealing with reducing latency in Microservices is to **not rely** on a purely **synchronous communication** model.
* We are impatient by nature, and we seem to always want systems that have immediate feedback (synchronous operations). But it is not always needed. Many times we can simply **defer the processing** to occur in an **asynchronous** manner. When we do this, we reduce the latency constraints on the functions that actually are required to be executed in real time.
* When moving to asynchronous operations, you need to take care to **handle error states correctly** and **recover from them**. If messages cannot be processed for any reason, you cannot simply ignore them. Dead letter queues must be monitored and action must be taken to process the messages even if it’s manual processing.

## :pushpin: Database Transaction Models: ACID vs BASE

* Traditional systems aimed for **ACID** model which provides a **consistent system**:
  * **Atomic** - either succeeds completely or fails completely.
  * **Consistent** - constraints of underlying datastore are enforced.
  * **Isolated** - cannot be read by other transactions until in a specific state based on isolation rules.
  * **Durable** - once saved, guaranteed to be in the datastore until modified.
* In Microservices Architecture, we embrace **BASE** model which provides **high availability**:
  * **Basically Available** - availability of data is achieved by spreading and replicating it across the nodes of the database cluster.
  * **Soft State** - developers are responsible for consistency.
  * **Eventually Consistent** - at some point it will be achieved. Data reads are still possible (even though they might not reflect the reality).
* Just as **SQL databases** are almost uniformly **ACID compliant**, some **NoSQL databases** also tend to conform to **BASE principles** like MongoDB, Cassandra and Redis.
* In a Microservices Architecture, you need to **identify where you truly need** ACID transactions and wrap service boundaries around those operations.

## :pushpin: Logging and Distributed Tracing

* When an issue arises in a Microservice Architecture, it can become **very difficult** to see all the moving parts.
* **Tracing** - concept of creating a **unique token called a trace** and using that trace in all internal logging events for that call stack.
* **Distributed Tracing** across a Distributed System is achieved when each service uses the trace and then passes it downstream to all the service calls it makes.

## :pushpin: Embracing DevOps

* The single most effective way to be successful in a Microservice Architecture is to build it into your culture. A **DevOps culture** is a perfect fit, because the two compliment each other’s strengths while mitigating the weaknesses.
* DevOps aims to bring the **conversation** between development and operations into **the same sphere**.
* Most of the issues from Microservices can be seen as operational issues (e.g. Distribution Tax which needs to be monitored).