# The Stream API

<!-- TOC -->
* [:pushpin: Map/Filter/Reduce algorithm implementation in JDK](#pushpin-mapfilterreduce-algorithm-implementation-in-jdk)
* [:pushpin: The Stream API](#pushpin-the-stream-api)
* [:pushpin: The Collectors API](#pushpin-the-collectors-api)
* [:pushpin: Building a Stream from Data in Memory](#pushpin-building-a-stream-from-data-in-memory)
* [:pushpin: Converting a For Loop to a Stream](#pushpin-converting-a-for-loop-to-a-stream)
* [:pushpin: Reducing Data to compute Statistics](#pushpin-reducing-data-to-compute-statistics)
* [:pushpin: Collecting Data from Streams to create Lists/Sets/Maps](#pushpin-collecting-data-from-streams-to-create-listssetsmaps)
<!-- TOC -->

Legend:
* :red_circle: - final class
* :green_circle: - class
* :orange_circle: - abstract class
* :white_circle: - interface

## :pushpin: Map/Filter/Reduce algorithm implementation in JDK

* Steps of the :star: **Map/Filter/Reduce algorithm** :star::
  * :star: **Map** :star: - **_changes the type_** of the data, **_does not change the number_** of elements. The mapping step **_respects the order_** of your objects
  * :star: **Filter** :star: - **_does not change the type_** of the data, **_changes the number_** of elements. You may end up with no data
  * :star: **Reduce** :star: - produces **_a result_**
* If we want to create **_an efficient implementation_** of the Map/Filter/Reduce algorithm, it **_should not duplicate any data_**. It should work in the same way, performance wise, as the **_iterative pattern_**. Map/Filter/Reduce algorithm implemented by the Collection API would cause **_duplication of the data_** (storing the data in an intermediate structure)
* :star: **The Stream API** :star: is an implementation of the Map/Filter/Reduce algorithm that **_does not duplicate any data_** and that **_does not create any load on the CPU or memory_** (Stream by definition is **_an empty object_** - it does not carry any kind of data)
* Every time you call a method on a Stream that returns another Stream, it is going to be **_a new Stream object_**
* Difference between the Stream API and iterative approach is that in the Stream API we **_describe the computation and not how this computation should be conducted_**. This is none of my business, this is the business of the API
* Reduce method triggers **_the computation of the elements_**, and those elements are going to be taken **_one-by-one, first mapped, then filtered and computed if they pass the filtering step_**. Using Streams is about **_creating pipelines of operations_**.
  * :star: **Intermediate operation (Map/Filter)** :star: - operation that creates a Stream (it does not do anything, it does not process any data)
  * :star: **Terminal operation (Reduce)** :star: - operation that produces a result (it will trigger the computation of the elements)
* If you have a pattern using a Stream that does not end up with a Terminal operation, your pattern is not going to process any data. **_It will be useless code_**
* You are **_not allowed_** to process **_the same Stream twice_**. This is why it is completely useless to create intermittent variables to store the Streams. **_You should inline it_**

## :pushpin: The Stream API

* The Stream API gives you **4** interfaces:
  * :white_circle: [`java.util.stream.Stream<T>`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/Stream.html) (`T` - the type of the Stream elements) - a sequence of elements supporting sequential and parallel aggregate operations
    * `map(Function<? super T,? extends R> mapper)` - returns a `Stream<R>` consisting of the results of applying the given function to the elements of this Stream
    * `mapToInt(ToIntFunction<? super T> mapper)` - returns an `IntStream` consisting of the results of applying the given function to the elements of this Stream
    * `flatMap(Function<? super T,? extends Stream<? extends R>> mapper)` - used to deal with one-to-many relationships between entities (e.g. collection in collection). FlatMap operation is defined by a Function that takes an object and returns a `Stream<R>` of other objects
      ```java
      long count = cities.stream() // 3 cities
        .flatMap(city -> city.getPeople().stream()) // With 3 people each
        .count(); // Returns 9
      ```
    * `filter(Predicate<? super T> predicate)` - returns a `Stream<T>` consisting of the elements of this Stream that match the given predicate
    * `reduce(BinaryOperator<T> accumulator)` - performs a reduction on the elements of this Stream, using an associative accumulation function, and returns an `Optional<T>` describing the reduced value, if any. See [Reducing Data to compute Statistics](#pushpin-reducing-data-to-compute-statistics)
    * `reduce(T identity, BinaryOperator<T> accumulator)` - performs a reduction on the elements of this Stream, using the provided identity value and an associative accumulation function, and returns the reduced value `T`. See [Reducing Data to compute Statistics](#pushpin-reducing-data-to-compute-statistics)
    * `collect(Collector<? super T,A,R> collector)` - performs a mutable reduction operation on the elements of this Stream using a :white_circle: [`java.util.stream.Collector<T,A,R>`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/Collector.html) (`T` - the type of input elements to the reduction operation, `A` - the mutable accumulation type of the reduction operation (often hidden as an implementation detail), `R` - the result type of the reduction operation). See [The Collector API](#pushpin-the-collectors-api) and [Collecting Data from Streams to create Lists/Sets/Maps](#pushpin-collecting-data-from-streams-to-create-listssetsmaps)
    * `distinct()` - returns a `Stream<T>` consisting of the distinct elements (according to `Object.equals(Object)`) of this Stream
    * `sorted()` - returns a `Stream<T>` consisting of the elements of this Stream, sorted according to natural order
    * `count()` - computes the count of elements and returns `long`
    * `min(Comparator<? super T> comparator)` or `max(Comparator<? super T> comparator)` - returns `Optional<T>` of the minimum or the maximum element of this Stream according to the provided `Comparator`
    * `toArray()` - returns an array `Object[]` containing the elements of this Stream
      * `toArray(String[]::new)` - returns `String[]`
  * :white_circle: [`java.util.stream.IntStream`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/IntStream.html) - `int` primitive specialization of Stream
    * `sum()` - computes the sum and returns `int`
    * `min()` or `max()` - computes the minimum or the maximum number and returns `OptionalInt`
    * `average()` - computes the average value of numbers and returns `OptionalDouble`
    * `summaryStatistics()` - returns `IntSummaryStatistics` object with statistics like count, sum, min, max and average
  * :white_circle: [`java.util.stream.LongStream`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/LongStream.html) - `long` primitive specialization of Stream. It has similar methods to `IntStream`
  * :white_circle: [`java.util.stream.DoubleStream`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/DoubleStream.html) - `double` primitive specialization of Stream. It has similar methods to `IntStream`

## :pushpin: The Collectors API

* :red_circle: [`java.util.stream.Collectors`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/Collectors.html) - implementations of `Collector` that implement various useful reduction operations, such as accumulating elements into collections, summarizing elements according to various criteria, etc.
  * `toList()` - returns a `Collector` that accumulates the input elements into a new `List`, in encounter order
  * `toUnmodifiableList()` - returns a `Collector` that accumulates the input elements into an unmodifiable `List`, in encounter order
  * `toSet()` - returns a `Collector` that accumulates the input elements into a new `Set`
  * `toUnmodifiableSet()` - returns a Collector that accumulates the input elements into an unmodifiable `Set`
  * `toCollection(Supplier<C> collectionFactory)` (e.g. `toCollection(MyCollection::new)`) - returns a `Collector` that accumulates the input elements into a new `Collection`, in encounter order
  * `joining()` - returns concatenated String without any separator. Only works with `Stream<String>`
    * `joining(", ")` - returns concatenated String separated with given separator
    * `joining(", ", "[", "]")` - returns concatenated String separated with given separator with `[` as prefix and `]` as suffix
  * `groupingBy(Function<? super T,? extends K> classifier)` (e.g. `groupingBy(City::getState)`) - returns a `Collector` implementing a "group by" operation on input elements of type `T`, grouping elements according to a classification function, and returning the results in a Map
  * `groupingBy(Function<? super T,? extends K> classifier, Collector<? super T,A,D> downstream)` - returns a `Collector` implementing a cascaded "group by" operation on input elements of type `T`, grouping elements according to a classification function, and then performing a reduction operation on the values associated with a given key using the specified downstream `Collector`
  * `counting()` - returns a `Collector` accepting elements of type `T` that counts the number of input elements
  * `summingInt(ToIntFunction<? super T> mapper)` (e.g. `summingInt(City::getPopulation)`) - returns a `Collector` that produces the sum of an integer-valued function applied to the input elements

## :pushpin: Building a Stream from Data in Memory

* Creating a Stream from **_Arrays_**:
  * :red_circle: [`java.util.Arrays`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/Arrays.html):
    * `stream(T[] array)` - returns a sequential `Stream<T>` with the specified array as its source
  * :white_circle: [`java.util.stream.Stream<T>`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/Stream.html)
    * `of(T... values)` - returns a sequential ordered `Stream<T>` whose elements are the specified values
* Creating a Stream from **_a Text File_**:
  * :red_circle: [`java.nio.file.Files`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/nio/file/Files.html)
    * `lines(Path path)` - read all lines from a file as a `Stream<String>`
  ```java
  Path path = Path.of("src/main/resources/first-names.txt"); // File with 200 lines
  try (Stream<String> lines = Files.lines(path)) {
      long count = lines.count(); // Returns 200
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```
* Creating a Stream from **_a RegEx_**:
  * :red_circle: [`java.util.regex.Pattern`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/regex/Pattern.html)
    * `splitAsStream(CharSequence input)` - creates a `Stream<String>` from the given input sequence around matches of this pattern
  ```java
  String sentence = "the quick brown fox jumps over the lazy dog";
  
  // Bad Practice: we create an Array and store it in memory
  String[] words = sentence.split(" ");
  long count1 = Arrays.stream(words).count(); // Returns 9
  
  // Best Practice: we do not create an Array when we create a Stream from Pattern
  long count2 = Pattern.compile(" ").splitAsStream(sentence).count(); // Returns 9
  ```
* Creating an `IntStream` **_(Stream of ASCII Codes)_** from a String:
  * :red_circle: [`java.lang.String`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/lang/String.html)
    * `chars()` - returns an `IntStream` of int zero-extending the char values from this sequence
  ```java
  String sentence = "the quick brown fox jumps over the lazy dog";
  sentence.chars()
    .mapToObj(codePoint -> Character.toString(codePoint)) // Converts IntStream to Stream<String>
    .filter(letter -> !letter.equals(" "))
    .distinct().sorted().forEach(System.out::print);
  ```
* Creating a Stream of Strings:
  ```java
  Stream<String> streamOfStrings = Stream.<String>of("abcd");
  ```
* **_Selecting_** elements of a Stream:
  ```java
  IntStream.range(0, 30)
    .skip(10) // Skip first 10 elements
    .limit(10) // Take next 10 elements after skip
    .forEach(index -> System.out.print(index + " ")); // Prints "10 11 12 13 14 15 16 17 18 19"
  ```
* **_Closing_** a Stream with **_a Predicate_**:
  * `takeWhile` - consume elements of the Stream until Predicate is **_true_**
  ```java
    Stream.<Class<?>>iterate(ArrayList.class, c -> c.getSuperclass())
      .takeWhile(c -> c != null)
      .forEach(System.out::println);
    // Prints:
    class java.util.ArrayList
    class java.util.AbstractList
    class java.util.AbstractCollection
    class java.lang.Object
    ```
  * `dropWhile` - consume remaining elements of the Stream after Predicate becomes **_false_**
  ```java
  Stream.<Class<?>>iterate(ArrayList.class, c -> c.getSuperclass())
    .dropWhile(c -> !c.equals(AbstractCollection.class))
    .forEach(System.out::println);
  // Prints
  class java.util.AbstractCollection
  class java.lang.Object
  null
  Exception in thread "main" java.lang.NullPointerException: Cannot invoke "java.lang.Class.getSuperclass()" because "c" is null
  ```

## :pushpin: Converting a For Loop to a Stream

* The following:
  ```java
  int sum = 0;
  int count = 0;
  for (Person person : people) {
    if (person.getAge() > 20) {
      count++;
      sum += person.getAge();
    }
  }
  double average = 0d;
  if (count > 0) {
    average = sum / count;
  }
  ```
  can be converted into:
  ```java
  double average = people.stream()
    .mapToInt(Person::getAge)
    .filter(age -> age > 20)
    .average().orElseThrow();
  ```
* The Stream API **_always computes one thing_**. Never sacrifice the **_readability_** of your code to the **_performance_**. The performance here is measured in **_nanoseconds_**:
  ```java
  double totalAmount = 0;
  int frequentRenterPoints = 0;
  String statement = composeHeader();
  for (Rental rental : rentals) {
      totalAmount += computeRentalAmount(rental);
      frequentRenterPoints += getFrequentRenterPoints(rental);
      statement += computeStatementLine(rental);
  }
  statement += composeFooter(totalAmount, frequentRenterPoints);
  ```
  can be converted into:
  ```java
  double totalAmount = rentals.stream()
    .mapToDouble(this::computeRentalAmount)
    .sum();
  int frequentRenterPoints = rentals.stream()
    .mapToInt(this::getFrequentRenterPoints)
    .sum();
  String statement = composeHeader();
  statement += rentals.stream()
    .map(this::computeStatementLine)
    .collect(Collectors.joining());
  statement += composeFooter(totalAmount, frequentRenterPoints);
  ```
* Forget about **_processing your data in one pass_** (unless you are doing **_an SQL request_**). Most of the time when you have a for loop or when you have a Stream, the JVM will optimize that for you and get rid of your for loop, get rid of your iteration, and you will have a zero pass of your data, just inline code, **_extremely performant, and extremely efficient_**. See [Fine-grained optimizations provided by JIT Compiler in Java](https://colinchjava.github.io/2023-10-25/08-46-54-893363-fine-grained-optimizations-provided-by-jit-compiler-in-java/)

## :pushpin: Reducing Data to compute Statistics

* The reduction of an empty Stream is :star: **_the identity element_** :star: of the reduction operation.
* `Stream#reduce` method can have **2** parameters: **_identity element_** and **_a Binary Operator_**. It adds this identity element before the elements of the Stream. If you have an empty Stream, it will **_return identity element_**. If you have only one element in the Stream, it will **_return the reduction of the identity element and this only element_**:
![stream-reduce.png](images/stream-reduce.png)
* Some reduction operations **_do not have any identity element_** (in case for the `IntStream#min`, the `IntStream#max`, the `IntStream#average` and `Stream#reduce` with only **1** parameter: a Binary Operator). **_Optionals_** are used by the Stream API, because in cases where we have an empty Stream without identity element **_we don't have any result_**.

## :pushpin: Collecting Data from Streams to create Lists/Sets/Maps

* :star: **Collector** :star: is a complex object **_used to reduce a Stream_**
  * Can be used to gather data in **_collections_** and **_maps_** - it is called as **_reduction in a "mutable container"_** or **_mutable reduction_**
* :star: **Downstream Collector** :star: - collector that is passed to `Collectors#groupingBy` which is applied to the streaming of the list of values
* :star: **The Collector API** :star: uses the `Stream#collect(Collector<? super T,A,R> collector)` that takes :white_circle: [`java.util.stream.Collector<T,A,R>`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/Collector.html) (`T` - the type of input elements to the reduction operation, `A` - the mutable accumulation type of the reduction operation (often hidden as an implementation detail), `R` - the result type of the reduction operation) implementation as a parameter
  * Use :red_circle: [`java.util.stream.Collectors`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/stream/Collectors.html) and their factory methods
  * You can create your own collectors, but it is complex and tricky
* Bad Practice:
  ```java
  List<Person> people = new ArrayList<>();
  List<Person> peopleFromNewYork = new ArrayList<>(); // Creating a List for results
  people.stream()
    .filter(p -> p.getCity().equals("New York"))
    .forEach(p -> peopleFromNewYork.add(p));
  ```
* Best Practice:
  ```java
  List<Person> people = new ArrayList<>();
  List<Person> peopleFromNewYork = people.stream()
    .filter(p -> p.getCity().equals("New York"))
    .collect(Collectors.toList()); // Using Collector
  ```
