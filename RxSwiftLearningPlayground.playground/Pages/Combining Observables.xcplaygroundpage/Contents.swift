import Foundation
import RxSwift
import RxCocoa

//: # Combining Observables

/*:
//: ### Combine Latest
 > Combines events received from it's subjects and send them as a single new event
 > Latest (or most recent) events only
 */

example("Combine Latest") {
    let bag = DisposeBag()
    var nextText: String = ""
    let A = PublishSubject<String>()
    let B = PublishSubject<Int>()
    Observable
        .combineLatest(A, B) { ($0,$1) }
        .subscribe(onNext: {
            print(nextText + " (\($0),\($1))")
        })
        .addDisposableTo(bag)
    print("A:[A]        B:[]    ->") //nothing happens because B hasn't emited an event yet
    A.onNext("A")
    nextText = "A:[A]        B:[1]   ->"
    B.onNext(1)
    nextText = "A:[A,B]      B:[1]   ->"
    A.onNext("B")
    nextText = "A:[A,B,C]    B:[1]   ->"
    A.onNext("C")
    nextText = "A:[A,B,C]    B:[1,2] ->"
    B.onNext(2)
}


/*:
//: ### Merge
 > Merges the events from different observers to a single one
 > they are not dependent from each other
 > Their elements must be of SAME TYPE or at least SAME SUBCLASS)
 */
example("Merge") {
    let bag = DisposeBag()
    var orderReceived = [String]()
    let a = PublishSubject<String>()
    let b = PublishSubject<String>()
    Observable.of(a, b)
        .merge()
        .subscribe(onNext: { orderReceived.append($0) })
        .addDisposableTo(bag)
    
    a.onNext("🅰️")
    a.onNext("🅱️")
    b.onNext("①")
    b.onNext("②")
    a.onNext("🆎")
    b.onNext("③")
    print("Order received: ", orderReceived)
}

/*:
//: ### Start With
 Starts a subscription with a new value inserted before others currently within the observable
 */
example("Start With") {
    let bag = DisposeBag()
    var insertedOrder: [String] = ["🐶","🐱","🐭","🐹","🅰️","🅱️","1️⃣", "2️⃣", "3️⃣"]
    var receivedOrder: [String] = []
    Observable.of("🐶", "🐱", "🐭", "🐹")
        .startWith("🅰️")
        .startWith("🅱️")
        .startWith("1️⃣", "2️⃣", "3️⃣")
        .subscribe(onNext: { receivedOrder.append($0) })
        .addDisposableTo(bag)
    print("Inserted Order: ", insertedOrder)
    print("Received Order: ", receivedOrder)
}

/*:
//: ### Switch
 A switch subscribes to a Observable that emits Observables and emits it's events
 Each time a new Observable is emitted, it will automatically unsubscribe from the previous one
 http://reactivex.io/documentation/operators/images/switch.c.png
 */
example("Switch") {
    let bag = DisposeBag()
    var nextString = ""
    let a = BehaviorSubject(value: "⚽️")
    let b = BehaviorSubject(value: "🍎")
    let variable = Variable(a)
    
    variable.asObservable()
        .switchLatest()
        .subscribe(onNext: { print(nextString, " received event: ", $0) })
        .addDisposableTo(bag)
    
    nextString = "A emited 🅰️,"
    a.onNext("🅰️")
    nextString = "A emited 🅱️,"
    a.onNext("🅱️")
    print("< Switching Variable >")
    variable.value = b
    nextString = "A emited : 🆎"
    a.onNext("🆎") //Event is ignored by switch
    nextString = "B emited ①,"
    b.onNext("①")
    nextString = "B emited ②,"
    b.onNext("②")
}

/*
//: ### Zip
 Combines the events received by it's subjects and sends them as a single event
 In the order received (combining indexes)
 Will only emit an event if all subjects have had an event
 */
example("Zip") {
    let bag = DisposeBag()
    let a = PublishSubject<String>()
    let b = PublishSubject<Int>()
    
    Observable.zip(a, b) { "\($0) \($1)" }
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
    
    a.onNext("🅰️")
    a.onNext("🅱️")
    b.onNext(1)
    b.onNext(2)
    print("< B Sent one now >")
    a.onNext("🆎")
    b.onNext(3)
    b.onNext(4)
}