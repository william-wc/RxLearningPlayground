/*:
 # Creating Observables - Subjects
 `Subjects` are a bridge / proxy that act both as an **`Observable` and `Observer`**
 
 So they can:
 * Reemit items it observed
 * Emit new items

 */
import Foundation
import RxSwift

/*:
 ## PublishSubject
 Broadcasts the events received by it's source, to all subscribers as soon as it is received 
 
 ![Publish Subject](publish.png)
 
 > This is the standard Subject for event-related targets (button, text, etc)
 */
example("Publisher") {
    let bag = DisposeBag()
    let subject = PublishSubject<String>()
    let subscribeObserver = { (_ observer: String) in
        printSubscribed(observer)
        subject
            .subscribe(onNext: { printEventReceived(observer, $0) })
            .addDisposableTo(bag)
    }
    let sendEvent = {(_ event: String) in
        printEventSent("", event)
        subject.onNext(event)
    }
    
    sendEvent("⚽️")         // Nobody listens
    subscribeObserver("🐔")
    sendEvent("🏀")         // Only 🐔 receives 🏀
    subscribeObserver("🐸")
    sendEvent("🏈")         // 🐔🐸 receive 🏈
}

/*:
 ## BehaviorSubject
 When an `Observer` subscribes to an `BehaviorSubject`, it begins by emiting the **most recent item** (which could also be the default)
 
 Then continues to emit any other items emitted by it's source Observable(s)
 
 ![Behavior Subject](behavior.png)
 */
example("Behavior") {
    let bag = DisposeBag()
    let subject = BehaviorSubject(value: "🔴") // this will be the default (initial) value
    let subscribeObserver = { (_ observer: String) in
        printSubscribed(observer)
        subject
            .subscribe(onNext: { printEventReceived(observer, $0) })
            .addDisposableTo(bag)
    }
    let sendEvent = {(_ event: String) in
        printEventSent("", event)
        subject.onNext(event)
    }

    subscribeObserver("🐔") // 🐔 receives 🔴 (default)
    sendEvent("⚽️")         // 🐔 receives ⚽️
    subscribeObserver("🐸") // 🐸 receives ⚽️
    sendEvent("🏀")         // 🐔🐸 receive 🏀
    subscribeObserver("🐙") // 🐙 receive 🏀
    sendEvent("🏈")         // 🐔🐸🐙 receive 🏈
}

/*:
 ## ReplaySubject
 When an `Observer` subscribes to an `ReplaySuject`, it begin by emitting the **last emitted items (buffer size)**
 
 > Differently from `BehaviorSubject`, it doesn't have a default / initial value
 >
 > And the *buffer* behaves as `FIFO`
 
 ![Replay Subject](replay.png)
 */
example("Replay") {
    let bag = DisposeBag()
    let subject = ReplaySubject<String>.create(bufferSize: 2) // buffer size 2
    let subscribeObserver = { (_ observer: String) in
        printSubscribed(observer)
        subject
            .subscribe(onNext: { printEventReceived(observer, $0) })
            .addDisposableTo(bag)
    }
    let sendEvent = {(_ event: String) in
        printEventSent("", event)
        subject.onNext(event)
    }
    
    subscribeObserver("🐔") // will receive nothing since subject has yet to emit an event
    sendEvent("⚽️")         // 🐔 receives ⚽️           <buffer:[⚽️]>
    subscribeObserver("🐸") // 🐸 receives ⚽️
    sendEvent("🏀")         // 🐔🐸 receive 🏀          <buffer:[⚽️,🏀]>
    sendEvent("🏈")         // 🐔🐸 receive 🏈          <buffer:[🏀,🏈]>
    subscribeObserver("🐙") // 🐙 receive 🏀 then 🏈
    sendEvent("⚾️")         // 🐔🐸🐙 receive ⚾️        <buffer:[🏈,⚾️]>
}
/*:
 ## Variable
 A `Variable` wraps the `BehaviorSubject`, in a way that it becomes easier to use
 
 *such as if it was a normal variable*
 */
example("Variable") {
    let bag = DisposeBag()
    let variable = Variable("🍔")
    printSubscribed("🐸")
    variable.asObservable()
        .subscribe(onNext: { print("🐱 received \($0)") })
        .addDisposableTo(bag)
    variable.value = "🍏"
    variable.value = "🍎"
    printSubscribed("🐸")
    variable.asObservable()
        .subscribe(onNext: { print("🐸 received \($0)") })
        .addDisposableTo(bag)
    variable.value = "🍐"
    variable.value = "🍊"
}

/*:
 ----
 [< Previous](@previous) |
 [Next >](@next)
 */
