/*:
 ![Rx Icon](RxLogo.png)

 # ReactiveX - Swift
 ## Observer Pattern
 An object (in this case an Observable), sends / emits events to a listener (or in this case an Observer)
 
 The Observable only emits data, while and Observer processes it
 
 ## What is ReactiveX?
 Combines the **Observer pattern, Iterator pattern** and **Functional programming** 
 
 In such a way that, it becomes appliable to almost any situation where you need to **process data** be it a sequence or not
 
 And it does that by adding _two semantics_ to the **GoF's Observer Pattern**:
 * The ability to iterate and finalize/complete the stream of data (by calling _onCompleted_)
 * The ability to signal the observer when an error occured (by calling _onError_)
 
 ## How?
 Instead of _delegates_ or _target-events_, it works by:
 * Binding a reaction to an expected action in a closure
 * Manipulating events, data and/or errors as needed
 * And compartmentalizing the memory cleanup afterwars
 * And also offers ways to manipulate events, errors and completions
 * Asynchronously
 
 It means that the framework itself doesn't have to padronize new methods for new pair of Observable-Observer
 
 It is all contained within the closure you specify for it
 
 All it has to do is handle and emit events/data/completion (handled differently depending on the subject) and errors (generic)
 
 ### Disclaimer
 All Images are provided by [reactiveX.io]: http://reactivex.io
 
 ----
 ### Table of Contents
 1. [Creating Observables](Creating)
 2. [Transforming Observables](Transforming)
 3. [Filtering Observables](Filtering)
 4. [Combining Observables](Filtering)
 5. [Error Handling Operators]()
 6. [Observable Utility Operators]()
 7. [Conditional and Boolean Operators]()
 8. [Mathematical and Aggregate Operators]()
 9. [Connectables]()
 
 
 */
