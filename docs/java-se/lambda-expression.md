# Lambda Expression

<!-- TOC -->
* [:pushpin: Implementing Functional Interfaces with Lambda Expression](#pushpin-implementing-functional-interfaces-with-lambda-expression)
* [:pushpin: Creating Lambdas with the JDK](#pushpin-creating-lambdas-with-the-jdk)
* [:pushpin: Invoking a Lambda Expression on Objects and primitive types](#pushpin-invoking-a-lambda-expression-on-objects-and-primitive-types)
* [:pushpin: Creating Lambda Expressions by chaining and composing other Lambda Expressions](#pushpin-creating-lambda-expressions-by-chaining-and-composing-other-lambda-expressions)
<!-- TOC -->

Legend:
* :red_circle: - final class
* :green_circle: - class
* :orange_circle: - abstract class
* :white_circle: - interface

## :pushpin: Implementing Functional Interfaces with Lambda Expression

* :star: **Lambda Expression** :star: is an implementation of **_a Functional Interface_**
* :star: **Functional Interface** :star: - an interface that has only **_one abstract method_**. These do not count:
  * Default methods
  * Static methods
  * :green_circle: [`java.lang.Object`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/lang/Object.html) methods (e.g. in :white_circle: [`java.util.Collection`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/Collection.html#equals(java.lang.Object)) you may find `Object` class methods which are changing the documentation of those methods)
* Lambda Expression **_is not another way_** of writing **_instances_** of **_anonymous classes_**. Anonymous class may implement **_any kind of interface_**, not necessarily functional, and it can extend **_any kind of class_**, whether it is a concrete class or an abstract class
* Sometimes people are saying that a Lambda Expression is **_an anonymous method_**
* Java is object-oriented programming language and thanks to introduction of Lambda Expression **_some patterns from functional programming_** have been added to it.
* Functional Interface **_may be annotated_** with the special annotation called [`@FunctionalInterface`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/lang/FunctionalInterface.html), but it's **_not mandatory_**. This is for backward compatibility (e.g. since `@FunctionalInterface` is optional, :white_circle: [`java.lang.Runnable`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/lang/Runnable.html) can be a functional interface)
* How to implement a Functional Interface **_in 3 easy steps_**:
  * copy and paste a **_block of parameters_** of an abstract method: `()`
  * draw an **_arrow operator_**: `->`
  * provide **_an implementation_** which is going to fit your needs

## :pushpin: Creating Lambdas with the JDK

* [`java.util.function`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/function/package-summary.html) package is organized in 4 categories:
  * :star: [**Suppliers**](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/function/Supplier.html) :star: - do not take any argument and return an object of `T` type. Supplier is used in the [`generate`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/Stream.html#generate(java.util.function.Supplier)) operation of the Stream API
    ```java
    public interface Supplier<T> {
        T get();
    }
    Supplier<String> supplier = () -> "Hello!";
    ```
  * :star: [**Consumers**](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/function/Consumer.html) :star: - consume an object of `T` type and do not return anything. Consumer is used in the [`forEach`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/Stream.html#forEach(java.util.function.Consumer)) operation of the Stream API
    ```java
    public interface Consumer<T> {
        void accept(T t);
    }
    Consumer<String> consumer = s -> System.out.println(s);
    ```
  * :star: [**Predicates**](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/function/Predicate.html) :star: - take an object of `T` type, test it and return `boolean`. Predicate is used in the [`filter`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/Stream.html#filter(java.util.function.Predicate)) operation of the Stream API
    ```java
    public interface Predicate<T> {
        boolean test(T t);
    }
    Predicate<String> predicate = s -> s.isEmpty();
    ```
  * :star: [**Functions**](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/function/Function.html) :star: - take an object of `T` type and return an object of `R` type. Function is used in the [`map`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/Stream.html#map(java.util.function.Function)) operation of the Stream API
    ```java
    public interface Function<T, R> {
        R apply(T t);
    }
    Function<LocalDate, Month> function = date -> date.getMonth();
    ```
* :white_circle: [`java.lang.Runnable`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/lang/Runnable.html) - does not take any argument and does not return anything. Defined to model task in Java concurrent programming
  ```java
  public interface Runnable {
      void run();
  }
  Runnable alert = () -> System.out.println("I am Groot");
  ```
* :white_circle: [`java.util.Comparator`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/Comparator.html) - takes two objects of `T` type, compares them and returns `int`. A comparison function, which imposes a total ordering on some collection of objects
  ```java
  public interface Comparator<T> {
      int compare(T o1, T o2);
  }
  Comparator<String> comparator = (s1, s2) -> s1.compareTo(s2);
  ```

## :pushpin: Invoking a Lambda Expression on Objects and primitive types

* Lambda Expressions are **_compiled using specific bytecode instruction_** called :star: [**invokedynamic**](https://blogs.oracle.com/javamagazine/post/understanding-java-method-invocation-with-invokedynamic) :star: introduced in Java 7
* **_Performance is 60x better in Lambda Expressions_** than Anonymous Classes. It can be even faster
* **_Avoid autoboxing and unboxing_** when writing Lambda Expressions. If you want to improve the performance you need to **_use specialized interfaces for primitive types_**
  ```java
  // Bad Practice: autoboxing and unboxing
  BiFunction<Integer, Integer, Integer> function1 = (i1, i2) -> Math.max(i1, i2);
  int max1 = function1.apply(10, 20);
  
  // Best Practice: use specialized interfaces for primitive types
  IntBinaryOperator function2 = (i1, i2) -> Math.max(i1, i2);
  int max2 = function2.applyAsInt(10, 20);
  ```

## :pushpin: Creating Lambda Expressions by chaining and composing other Lambda Expressions

* Lambda Expressions can be chained by using **_default methods of the interface_**
* Creating a Consumer by chaining two Consumers:
  ```java
  Consumer<String> c1 = s -> System.out.println("c1 consumes " + s);
  Consumer<String> c2 = s -> System.out.println("c2 consumes " + s);
  Consumer<String> c3 = c1.andThen(c2);
  c3.accept("Hello");
  // Prints
  c1 consumes Hello
  c2 consumes Hello
  ```
* Creating a Predicate by chaining two Predicates:
  ```java
  Predicate<String> isNull = s -> s == null;
  Predicate<String> isEmpty = s -> s.isEmpty();
  Predicate<String> notNullAndNotEmpty = isNull.negate().and(isEmpty.negate());
  System.out.println("For null = " + notNullAndNotEmpty.test(null));
  System.out.println("For empty = " + notNullAndNotEmpty.test(""));
  System.out.println("For Hello = " + notNullAndNotEmpty.test("Hello"));
  // Prints
  For null = false
  For empty = false
  For Hello = true
  ```
* Creating a Comparator with Factory Method:
  ```java
  List<String> strings = Arrays.asList("one", "two", "three", "four", "five");
  
  // Bad Practice: autoboxing and unboxing
  Comparator<String> cmp1 = (s1, s2) -> Integer.compare(s1.length(), s2.length());
  strings.sort(cmp1);
  
  // Best Practice: use specialized interfaces for primitive types
  ToIntFunction<String> toLength = s -> s.length();
  Comparator<String> cmp2 = Comparator.comparingInt(toLength);
  strings.sort(cmp2);
  ```
* Creating a Comparator by chaining two Comparators:
  ```java
  User sarah = new User("Sarah", 28);
  User james = new User("James", 35);
  User mary = new User("Mary", 33);
  User john1 = new User("John", 24);
  User john2 = new User("John", 25);
  List<User> users = Arrays.asList(sarah, james, mary, john1, john2);

  Comparator<User> cmpName = Comparator.comparing(user -> user.getName());
  Comparator<User> cmpAge = Comparator.comparingInt(user -> user.getAge());
  Comparator<User> comparator = cmpName.thenComparing(cmpAge);
  Comparator<User> reversed = comparator.reversed();
  users.sort(reversed);
  users.forEach(user -> System.out.println(user));
  // Prints
  User{name='Sarah', age=28}
  User{name='Mary', age=33}
  User{name='John', age=25}
  User{name='John', age=24}
  User{name='James', age=35}
  ```
