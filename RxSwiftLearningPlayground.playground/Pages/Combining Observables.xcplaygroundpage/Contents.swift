/*: 
 # Combining Observables
 Operators that work with multiple source `Observables` to create a single `Observable`
*/
import Foundation
import RxSwift
/*:
 ## Merge
 Combine multiple `Observables` into one by merging their emissions *(but not their elements)*
 > Their elements must be of **same type** (or at least **same subclass**)
 
 ![Merge](merge.png)
 */
example("Merge") {
    let bag     = DisposeBag()
    let frog    = PublishSubject<String>()
    let chicken = PublishSubject<String>()
    
    func frogSends(_ event: String) {
        printEventSent("🐸", event)
        frog.onNext(event)
    }
    func chickenSends(_ event: String) {
        printEventSent("🐔", event)
        chicken.onNext(event)
    }
    
    Observable.of(frog, chicken)
        .merge()
        .subscribe(onNext: { printEventReceived("🌝", $0) })
        .addDisposableTo(bag)
    
    frogSends("⚽")
    chickenSends("🏈")
    frogSends("🏀")
    frogSends("🎾")
    frogSends("🏐")
    chickenSends("🏉")
}

/*:
 ## Combine Latest
 When an Item is emitted by either `Observable`, combine the **latest** item emitted by **each** via a *function* and emit the result(s)
 > Unlike `merge`, the source `Observables` don't have to be necessarily from same type
 
 ![Combine Latest](combine_latest.png)
 */
example("Combine Latest") {
    let bag = DisposeBag()
    var nextText: String = ""
    let A = PublishSubject<String>() // Sources don't have to be
    let B = PublishSubject<Int>()    // Necessarialy of same type
    
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
 ## Start With
 Emit a specified sequence of items *before* beginning to emit the items from the source `Observable`
 
 ![Start With](start_with.png)
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
 ## Switch
 Convert an `Observable` that emits `Observables` into a single `Observable` that emits the items emitted by the most-recently-emitted of those `Observables`
 
 ![Switch](switch.png)
 */
example("Switch") {
    let bag = DisposeBag()
    var nextString = ""
    let chicken = BehaviorSubject(value: "🍏")
    let hamster = BehaviorSubject(value: "🍉")
    
    func chickenSends(_ event: String) {
        printEventSent("🐔", event)
        chicken.onNext(event)
    }
    func hamsterSends(_ event: String) {
        printEventSent("🐹", event)
        hamster.onNext(event)
    }
    
    let variable = Variable(chicken)
    variable.asObservable()
        .switchLatest()
        .subscribe(onNext: { printEventReceived("🐙", $0) })
        .addDisposableTo(bag)
    
    chickenSends("🍊")
    print("< Switching Variable to 🐹 >")
    variable.value = hamster
    chickenSends("🍎") //Event is ignored by switch
    hamsterSends("🍆")
}

/*:
 ## Zip
 Combines the events received by it's subjects and sends them as a single event
 In the order received *(combining indexes)*
 
 Will only emit an event if all subjects have had an event *(at same index)*
 
 ![Zip](zip.png)
 */
example("Zip") {
    let bag     = DisposeBag()
    let panda   = PublishSubject<String>()
    let chicken = PublishSubject<Int>()
    
    func pandaSends(_ event: String) {
        printEventSent("🐼", event)
        panda.onNext(event)
    }
    func chickenSends(_ event: Int) {
        printEventSent("🐔", event)
        chicken.onNext(event)
    }
    
    Observable.zip(panda, chicken) { "(\($0),\($1))" }
        .subscribe(onNext: { printEventReceived("🌝", $0) })
        .addDisposableTo(bag)
    pandaSends("🍉") // Nothing happens
    pandaSends("🍏") // Nothing happens
    chickenSends(11) // Zip (0,0)
    chickenSends(22) // Zip (1,1)
    pandaSends("🍎") // Nothing happens
    chickenSends(33) // Zip (2,2)
    chickenSends(44) // Nothing happens
}


/*:
 ----
 [< Previous](@previous) |
 [Next >](@next)
 */
