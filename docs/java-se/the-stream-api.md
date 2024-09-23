# The Stream API

<!-- TOC -->
* [:pushpin: Map/Filter/Reduce algorithm implementation in JDK](#pushpin-mapfilterreduce-algorithm-implementation-in-jdk)
* [:pushpin: The Stream API](#pushpin-the-stream-api)
* [:pushpin: The Collectors API](#pushpin-the-collectors-api)
* [:pushpin: Building a Stream from Data in Memory](#pushpin-building-a-stream-from-data-in-memory)
* [:pushpin: Converting a For Loop to a Stream](#pushpin-converting-a-for-loop-to-a-stream)
* [:pushpin: Reducing Data to compute Statistics](#pushpin-reducing-data-to-compute-statistics)
* [:pushpin: Collecting Data from Streams to create Lists/Sets/Maps](#pushpin-collecting-data-from-streams-to-create-listssetsmaps)
* [:pushpin: Parallelism in the Stream API](#pushpin-parallelism-in-the-stream-api)
* [:pushpin: Getting the best performance gains from Parallel Streams](#pushpin-getting-the-best-performance-gains-from-parallel-streams)
* [:pushpin: Fork/Join framework implementation of Parallel Streams](#pushpin-forkjoin-framework-implementation-of-parallel-streams)
* [:pushpin: Choosing the right sources of data to efficiently go parallel](#pushpin-choosing-the-right-sources-of-data-to-efficiently-go-parallel)
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

## :pushpin: Parallelism in the Stream API

* You can make a regular Stream a Parallel Stream in two ways:
  * by calling `.parallel()` method on existing stream
  * by calling `.parallelStream()` method instead of calling `.stream()`
* These intermediate operations are going to set a special bit in the Stream that will trigger the computations in parallel when you call your terminal operation. After terminal operation is called, the Stream implementation will check this special bit: if it is set to 1, then the computation will happen in parallel and will trigger special algorithms for that, otherwise it will be processed sequentially.
* **JMH (Java Microbenchmark Harness)** (https://openjdk.org/projects/code-tools/jmh/) - standard tool to measure the performances of your Java code
* To proper measure the performance of a Java application you first need to run it a certain number of times (warmup), because within JVM there is a special just-in-time C2 compiler that can optimize your code a lot

## :pushpin: Getting the best performance gains from Parallel Streams

* Beware, because in below example you'll have **two unboxing** and **one boxing** (which have an impact on performance!):
  ```java
  Integer j = 3;
  Integer l = 4;
  Integer k = j + l;
  ```
* Similarly, iterating and doing some operation over array of `int` will be much faster than over array of `Integer` (due to unboxing and boxing).
* Each physical core of the CPU access two levels of cache, which are private: the first level of cache (small, very fast) and second level of cache (bigger, little slower). Third level of cache is shared by all physical cores (bigger, little slower). Main memory lives outside the CPU and is accessed much slower than third level of cache:
![cpu-caches.png](images/cpu-caches.png)
* How does a core of CPI access data from the main memory? This data will have to be transferred first to the L3 cache, then to the L2 cache, and then to the L1 cache before being available by this core of CPU.
* The memory is not read in a random way. If a core of CPU wants to access just an int, it will transfer line of memory, not just an int. The memory is transferred line by line from the main memory to the different levels of cache. Each line is typically 64 bytes (8 longs or 16 ints).
* When we have an array of references to the instance of the `Integer` which are going to hold the values: in one read operation we are only going to transfer the references to this object. And then to get all the values it may be several read to maximum 16 reads to get all the values of those integers. This is called **Pointer Chasing** which you need to avoid. To get all the values, we have to follow pointers to other places in the memory which has a cost due to the way that data is transferred from the main memory to the cache of the CPU.
* Iterating on a `LinkedList` will imply much more Pointer Chasing than iterating on an `ArrayList`. `LinkedList` does not store references to the Integers in an array. It stores them in a linked list of node objects. So first, you need to get the first reference to the first node object, and then you need to follow two pointers: the first one to the next node object and the second one to the Integer itself.
* **Cache Miss** - whenever the core of a CPU needs a value and that value turns out not to be in the cache. During the Cache Miss, if the value is not in the L2 cache or L3 cache, then the CPU may decide to suspend the threat that is executing this computation and replace it by another thread. This is a much bigger performance hit than just Pointer Chasing, but it is still a consequence of Pointer Chasing.
* This is why LinkedLists are called cache-unfriendly structures, whereas ArrayLists are called cache-friendly structures.

## :pushpin: Fork/Join framework implementation of Parallel Streams

* Fork/Join framework has been introduced in Java 7 and slightly modified in Java 8.
* Going parallel means that this task is going to be split into subtasks and each subtask is going to produce a partial result (fork step). When those partial results have been computed, they are going to be sent back to the main task that has the responsibility of joining them (join step).
* All those tasks are sent to a special pool of thread called ForkJoinPool and this pool has special capabilities to enable the computations of those subtasks in parallel.
* Fork/Join Framework decides whether the task is too big and should be split, or small enough and should be computed.
* Fork/Join pool:
  * is a pool of threads, instance of the :green_circle: `java.util.concurrent.ForkJoinPool`
  * created when the JVM is created
  * there is only one common `ForkJoinPool` in the JVM since Java 8
  * it is used for all the Parallel Streams
  * the size is fixed by the number of virtual cores (not necessarily a good thing) and can be changed with `java.util.concurrent.ForkJoinPool.common.parallelism` system property
* Suppose we have a common Fork/Join pool with 2 threads in it. Each thread is also associated with a waiting queue that can accept tasks. Suppose we have a task to compute. The first step is to split this task (A) into subtasks (A11, A12). Since parent task (A) is waiting for the partial results computed by its subtasks, it will be put at the end of the waiting queue thus freeing the first thread that is going to be able to handle the task A11. Fork/Join framework implements a trick that is quite classical in concurrent programming that is called work stealing. Since second thread is not working, it is able to steal some tasks from another waiting queue. So second thread will steal a task A12 from first thread, that is busy with A11 task and all threads will be busy. Once all subtasks will finish computation, the results will be passed to A task which will apply the reduce operator.
* You need to bench you own computation to be able to tell where your sweet spot is going to be in your use case. E.g. computing the sum of 10 integers in array is much faster sequentially than in parallel, however computing the sum of several millions integers in array will be much faster in parallel.
* You also need to check that on a machine that is as close as possible as your production machine.
* Synchronization is a feature within the Java language which prevents two thread from executing the same piece of code. In the Stream API there are operations (intermediate and terminal) that need to exchange data or exchange information with the other threads and perform hidden synchronization which is a bottleneck, e.g. `findFirst()` (`findAny()` will provide you much better performance in parallel) and `limit(100)` methods.
* If your binary operator from `reduce` method is not associative, then you are going to compute wrong results in both: sequential and parallel computing. In parallel, you can also get different results each time. Associative means that first computation gives out the same result as the second computation. Example:
  ```java
  // Given: [1, 1, 1, 1]
  // the below should return 4.
  // But since it is not associative binary operator,
  // it will compute 2 (1+1), then 5 (4+1), and it will return 26 (25+1)
  stream.reduce(0, (i1, i2) -> i1*i1 + i2*i2);
  ```
* You can display the thread executing your parallel stream with:
  ```java
  Set<String> threadNames = ConcurrentHashMap.newKeySet();
  stream.parallel().(...)
    .peek(i -> threadNames.add(Thread.currentThread().getName()))
    .(...);
  threadNames.forEach(System.out::println);
  ```
* You can execute a parallel stream in a custom ForkJoinPool, display the threads executing your parallel stream and count the number of tasks each thread executed with:
  ```java
  Map<String, Long> threadMap = new ConcurrentHashMap<>();
  ForkJoinPool forkJoinPool = new ForkJoinPool(4); // with 4 threads
  Callable<Integer> task = () -> {
    int result = stream.parallel().(...)
      .peek(i -> threadMap.merge(Thread.currentThread().getName(), 1L, Long::sum))
      .(...);
    return result;
  };
  ForkJoinTask<Integer> submit = forkJoinPool.submit(task);
  submit.get();
  threadMap.forEach((name, n) -> System.out.println(name + " -> " + n));
  forkJoinPool.shutdown();
  ```

## :pushpin: Choosing the right sources of data to efficiently go parallel

* The Fork step in Fork/Join framework works best based on two assumptions:
  * The number of elements is known before processing them. These sources of data do not meet this condition:
    * Iterator
    * Pattern
    * Lines of a text file
  * Reaching the center of the data must be easy, reliable and efficient. This source of data does not meet this condition:
    * LinkedList
* Fork/Join framework splits the array in two pieces and doesn't know if there is the same amount of data in the first half and in the second half. This information is not available, unless you count all the elements, one by one, in each half. The framework doesn't do that, because it would be too costly.
* Those two halves are going to be split again, and again, and again. Some of the segments of this array are going to be empty. Become higher and higher as the number of splitting increases. This is a problem with Sets-like structures.
* Sizeable - the number of elements of the source is known. All the collections and the arrays are sizeable, but all the patterns, lines and iterators are not sizeable.
* Subsizeable - the number of elements of the two split sources is known. Sets are sizeable, but they are not subsizeable.
* Processing data from a list is much faster than the processing data from a set because iterating over the elements of a list is faster than iterating over the elements of a set.
* Going parallel as a list will bring you more performance gain than going parallel in a set.
* You may have data to process that, in fact, is not well spread over all the buckets of the array that is backing your set (e.g. lines of strings that all return 0 hash code will be handled by only one thread).
* Are you sure that your threads should be used to compute your streams in parallel? In case of web application your threads are used to serve your HTTP clients, so you don't want those threads to be used for anything else, including parallel streams. The same goes for threads that are used for SQL transactions. Threads are precious resources.
