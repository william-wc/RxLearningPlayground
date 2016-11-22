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
 1. [Observables and Observers](Observables%20and%20Observers)
 2. [Creating Observables](Creating%20Observables)
 3. [Subjects](Subjects)
 4. [Transforming Observables](Transforming%20Observables)
 5. [Filtering Observables](Filtering%20Observables)
 6. [Combining Observables](Combining%20Observables)
 7. [Error Handling Operators](Error%20Handling%20Operators)
 8. [Conditional and Boolean Operators](Conditional%20And%20Boolean%20Operations)
 9. [Mathematical and Aggregate Operators](Mathematical%20And%20Aggregate%20Operators)
 10. [Observable Utility Operators](Observable%20Utility%20Operators)
 
 */
