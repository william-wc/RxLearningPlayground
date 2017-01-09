/*:
 # Creating Observables
 Here are examples of the simples observer cases, where you already have all data it should emit to a new subscriber
 
 ----
 */
import Foundation
import RxSwift

/*:
 ## Empty
 Sends only the **`completed`** event
 
 ![Empty](empty.png)
 */
example("Empty") {
    let bag = DisposeBag()
    Observable.empty()
        .subscribe { (e: Event<Any>) in
            switch e {
            case .next(_):      printEventReceived("🐑", "Nothing")
            case .completed:    printEventReceived("🐑", "Completed")
            case .error(_):     printEventReceived("🐑", "Error")
            }
        }
        .addDisposableTo(bag)
}

/*:
 ## Throw
 * Sends only an **error** event
 
 ![Throw](throw.png)
 */
example("Throw") {
    let bag = DisposeBag()
    Observable.error(SimpleError.ez)
        .subscribe { (e: Event<Any>) in
            switch e {
            case .next(_):      printEventReceived("🐑", "Nothing")
            case .completed:    printEventReceived("🐑", "Completed")
            case .error(_):     printEventReceived("🐑", "Error")
            }
        }
        .addDisposableTo(bag)
}

/*:
 ## Never
 Doesn't send any events, ergo, it **never** finishes
 
 ![Never](never.png)
 */
example("Never") {
    let bag = DisposeBag()
    Observable.never()
        .subscribe { (e: Event<Any>) in
            switch e {
            case .next(_):      printEventReceived("🐑", "Nothing")
            case .completed:    printEventReceived("🐑", "Completed")
            case .error(_):     printEventReceived("🐑", "Error")
            }
        }
        .addDisposableTo(bag)
}

/*:
 ## Just
 This `Observable` contains only *one* element
 
 It will send an event with the element, then the completion event
 
 ![Just](just.png)
 */
example("Just") {
    let bag = DisposeBag()
    Observable
        .just("🍏")
        .subscribe(onNext: { printEventReceived("🐓", $0) })
        .addDisposableTo(bag)
    // After this context example of "Simple Observer" is destroyed
    // The bag goes with it, taking the <anonymous> observer we added when we subscribed
}
/*:
 ## From / Of
 This `Observable` contains a collection of elements, *from the same **type***
 
 After sending each element, will send the completion event
 
 ![From](from.png)
 */
example("Of") {
    let bag = DisposeBag()
    Observable
        .from(["🍏","🍎","🍐","🍊","🍋"])
        //.of("🍏","🍎","🍐","🍊","🍋")        // Since Swift accepts Variadic Parameters, it can be defined by `.of` or `.from`
        .subscribe(onNext: { printEventReceived("🐓", $0) })
        .addDisposableTo(bag)
}

/*:
 ## Generate
 Creating an `Observable` using: 
 * Initial state
 * Continuing condition
 * Iteration
 
 Useful to generate a sequence of elements
 */
example("Generate") {
    let bag = DisposeBag()
    Observable
        .generate(initialState: 0,
                  condition: { $0 < 10 }, // Once the condition gets it's first `false`, it will stop generating values
                  iterate: { $0 + 2 })
        .subscribe(onNext: { printEventReceived("🐓", $0) })
        .addDisposableTo(bag)
}

/*:
 ## Create
 Creating an `Observable` with a closure
 
 Useful when dealing with data that *mutates* according to the *enviroment*
 
 ![Create](create.png)
 */
example("Create") {
    let bag = DisposeBag()
    Observable.create({ observer -> Disposable in
        observer.on(.next("☃️"))
        observer.onNext("🔥")
        // Sending the completion event, without it the observer will be kept alive (within the bag)
        // And your observers will never know when it's finished
        observer.on(.completed)
        return Disposables.create()
    }).subscribe(onNext: { printEventReceived("", $0) })
        .addDisposableTo(bag)
}
/*:
 ## Defer
 Much like the above, a *`deferred Observer`* is actually a **factory** of *`Observers`*
 
 Which means: 
 * It waits for subscriptions
 * And every time there is a new subscription, it will **generate** a new *`Observable`*
 
 ![Defer](defer.png)
 */
example("Defer") {
    let bag = DisposeBag()
    var count = 0
    let observable = Observable.deferred({ () -> Observable<Int> in
        count += 1
        return Observable.create({ observer -> Disposable in
            observer.on(.next(count * 1))
            observer.on(.next(count * 2))
            observer.on(.next(count * 3))
            observer.on(.next(count * 4))
            observer.on(.completed)
            return Disposables.create()
        })
    })
    // This one will receive [1,2,3,4]
    observable.subscribe(onNext: { printEventReceived("🎃", $0.description) }).addDisposableTo(bag)
    // This one will receive [2,4,6,8]
    observable.subscribe(onNext: { printEventReceived("🌎", $0.description) }).addDisposableTo(bag)
}

/*:
 ## RepeatElement
 Creates an `Observer` with just one element, but repeated indefinitely.
 
 But since `Observers` are **lazy** by design, it will emit these elements **only** when there is a subscription
 */
example("Repeat Element") {
    let bag = DisposeBag()
    Observable.repeatElement("Just")
        .take(5) // if you remove this line, it will run indefinetly. .take() will be explained later
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
}

/*:
 `Observable` that emits elements with time intervals between emissions
 */
example("Observer Repeating Element with Time") {
    let bag = DisposeBag()
    // Helper function
    makeObserver(interval: 0.2, contents: ["🌕","🌖","🌗","🌘","🌚"])
        .subscribe(onNext: { printEventReceived("🌞", $0.description) })
        .addDisposableTo(bag)
    // Just making sure playground won't interrupt execution before observer ends
    Thread.sleep(forTimeInterval: 2)
}

/*:
 ----
 > Even though an *`Observable`* is the same, when an *`Observer`* subscribe to it, it has to go through the same values in the same order as all the others
 >
 > This is only true to the simple implementation, not involving **Subjects** or **Operators**
 >
 > *(More on this will be expanded later)*
 */
example("Multiple Observers") {
    let bag = DisposeBag()
    let values = ["🍏","🍎","🍐","🍊","🍋"]
    let observable = Observable
        .from(values)
    print("Values in observer: ", values)
    // First <anonymous> Observer
    observable
        .subscribe(onNext: { printEventReceived("🐑", $0) })
        .addDisposableTo(bag)
    // Second <anonymous> Observer
    observable
        .subscribe(onNext: { printEventReceived("🐿", $0) })
        .addDisposableTo(bag)
    // Both will go through the same values, at the same order
    // More on this is explained in `Subjects`
}

/*:
 ----
 [< Previous](@previous) |
 [Next >](@next)
 */
