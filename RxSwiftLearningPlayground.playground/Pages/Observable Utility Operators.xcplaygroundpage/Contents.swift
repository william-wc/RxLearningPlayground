/*:
 # Observable Utility Operators
 Operators that evaluate one or more `Observabls` or item emitted by `Observables`
 */
import Foundation
import RxSwift
/*:
 ## Do
 Register an action to take upon an event
 * `onNext`
 * `onError`
 * `onCompleted`
 * `onSubscribe`
 * `onDispose`
 
 ![Do](do.png)
 */
example("Do") {
    let bag = DisposeBag()
    Observable.of("⚽","🏀","🏈").do(
        onNext: { printEventReceived("🐸", $0) },
        onError: { printErrorReceived("🐸", $0) },
        onCompleted: { print("🐸 completed") },
        onSubscribe: { print("🐸 subscribed") },
        onDispose: { print("🐸 disposed") })
        .subscribe { printEventReceived("🐼", $0) }
        .addDisposableTo(bag)
}


/*:
 ## Observe On
 Specify the scheduler on which an `observer` will observe this `Observable`
 
 ### Schedulers
 * MainScheduler
 * ConcurrentMainScheduler
 * HistoricalScheduler
 * HistoricalSchedulerTimeConverter
 * VirtualTimeScheduler
 * OperationQueueScheduler
 * SerialDispatchQueueScheduler
 * ConcurrentDispatchQueueScheduler
 * CurrentThreadScheduler
 
 ![Observe on](observe_on.png)
 */
example("Observe On") {
    // TODO expand more on this topic
    let bag = DisposeBag()
    print("One")
    Observable.of(0,1,2)
        .observeOn(MainScheduler.instance)
        .subscribe { printEventReceived("🐼", $0) }
        .addDisposableTo(bag)
    print("Two")
}

/*:
 ## Subscribe On
 Similar to `Observe On`, it specifies which Scheduler an `Observable` will operate
 
 ![Subscribe On](subscribe_on.png)
 */
example("Subscribe On") {
    // TODO expand more on this topic
    let bag = DisposeBag()
    print("One")
    Observable.of(0,1,2)
        .subscribeOn(CurrentThreadScheduler.instance)
        .subscribe { printEventReceived("🐼", $0) }
        .addDisposableTo(bag)
    print("Two")
}

/*:
 ## Serialize
 Force an `Observable` to make serialized calls:
 > `Observable` is capable of invoking it's observer's methods asynchronously, this could lead to problems such as 
 > 
 > `onNext, onError or onCompleted` methods being called in the wrong order
 >
 > This is what `Serialize` tries to solve, by forcing them to behave as if they were being called in synch
 
 ![Serialize](serialize.png)
 */



/*:
 ## Timeout
 **Mirrors** the source `Observable` but issue an error if a specified period of time has passed without any emitted items
 
 ![Timeout](timeout.png)
 */
var persistentBag: DisposeBag?
example("Timeout Error") {
    let bag = DisposeBag()
    let frog = PublishSubject<String>()
    func frogSends(_ event: String) {
        printEventSent("🐸", event)
        frog.onNext(event)
    }
    frog.do(onNext: nil,
            onError: { printErrorReceived("🐸", $0) },
            onCompleted: { print("🐸 completed") },
            onSubscribe: { print("🐸 subscribed") },
            onDispose: { print("🐸 disposed") })
        .timeout(0.1, scheduler: MainScheduler.instance)
        .subscribe { printEventReceived("🌝", $0) }
        .addDisposableTo(bag)
    frogSends("⚽")
    DispatchQueue.global()
        .asyncAfter(deadline: .now() + 0.2) { //time
            frogSends("🏀")
            frog.onCompleted()
    }
    persistentBag = bag
}

// Keeping playground alive
playgroundTimeLimit(seconds: 10)

/*:
 ----
 [< Previous](@previous) |
 [Next >](@next)
 */
