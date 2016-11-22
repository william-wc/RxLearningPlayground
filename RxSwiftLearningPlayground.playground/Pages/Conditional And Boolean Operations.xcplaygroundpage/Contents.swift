/*:
 # Conditional and Boolean Operators
 Operators that evaluate one or more `Observables` or items emitted by them
 */
import Foundation
import RxSwift
/*:
 ## Amb
 Given *two or more* `Observables`, emit all of the items from only the first of these `Observables` to emit an item
 > Amb will ignore or discart the emissions and notifications of all of the other source `Observables`
 >
 > Must be of same type
 
 ![AMB](amb.png)
 */
example("Amb") {
    let bag = DisposeBag()
    let frog = PublishSubject<String>()
    let chicken = PublishSubject<String>()
    frog.amb(chicken)
        .subscribe(onNext: { printEventReceived("🌝", $0) })
        .addDisposableTo(bag)
    frog.onNext("🐸")
    chicken.onNext("🐔")
    chicken.onNext("🐔")
    chicken.onCompleted() //even through chicken completed first, frog was the first to emit
    frog.onNext("🐸")
}

/*:
 # Skip Until
 Discard items emiited by an `Observable` until a second `Observable` emits an item
 
 ![Skip Until](skip_until.png)
 */
example("Skip Until") {
    let bag = DisposeBag()
    let frog = makeObserver(interval: 0.1, contents: [0,1,2,3,4,5,6,7,8,9])
    let chicken = PublishSubject<String>()
    print("🐸 started")
    frog.skipUntil(chicken)
        .subscribe(onNext: { printEventReceived("🐸", $0) })
        .addDisposableTo(bag)
    // ignoring ~ [5;6] x 🐸
    Thread.sleep(forTimeInterval: 0.5)
    print("🐔 sent")
    chicken.onNext("🐔")
    Thread.sleep(forTimeInterval: 1.3) //giving enough time to run through frog
}

/*:
 # Skip While
 Discard items emiited by and `Observable` until a *specified condition* becomes **false**
 
 ![Skip While](skip_while.png)
 */
example("Skip While") {
    let bag = DisposeBag()
    Observable.of("🍉","🍏","🍎","🍐","🍊","🍋","🍌","🍇","🍓")
        .skipWhile { $0 != "🍊" }
        .subscribe(onNext: { printEventReceived("🦁", $0) })
        .addDisposableTo(bag)
}

/*:
 # Take Until
 Discard items emitted by an `Observable` after a second Observable emits an item or terminates
 
 ![Take Until](take_until.png)
 */
example("Take Until") {
    let bag = DisposeBag()
    let frog = makeObserver(interval: 0.1, contents: [0,1,2,3,4,5,6,7,8,9])
    let chicken = PublishSubject<String>()
    print("🐸 started")
    frog.takeUntil(chicken)
        .subscribe(onNext: { printEventReceived("🐸", $0) })
        .addDisposableTo(bag)
    Thread.sleep(forTimeInterval: 0.5)
    print("🐔 sent")
    chicken.onNext("🐔") // ignoring the rest from 🐸
    Thread.sleep(forTimeInterval: 1.3) //giving enough time to run through frog
}

/*:
 # Take While
 Discard items emitted by an `Observable` after a specified condition becomes false
 
 ![Take While](take_while.png)
 */
example("Skip While") {
    let bag = DisposeBag()
    Observable.of("🍉","🍏","🍎","🍐","🍊","🍋","🍌","🍇","🍓")
        .takeWhile { $0 != "🍊" }
        .subscribe(onNext: { printEventReceived("🦁", $0) })
        .addDisposableTo(bag)
}

/*:
 ----
 [< Previous](@previous) |
 [Next >](@next)
 */
