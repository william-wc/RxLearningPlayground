/*:
 # Mathematical and Aggregate Operators
 Operators that operate on the entire sequence of items emitted by an Observable 
 
 It is a complement of `Transforming Observables`
*/
import Foundation
import RxSwift


/*: 
 ## Concat
 Concatenates the elements in a sequential manner, waiting for each sequence to terminate before emiting the next one's values
 
 ![Concat](concat.png)
*/
example("Concat") {
    let bag = DisposeBag()
    var receivedOrder = [String]()
    let panda       = ReplaySubject<String>.createUnbounded()
    let hamster     = ReplaySubject<String>.createUnbounded()
    
    func pandaSends(_ event: String) {
        printEventSent("🐼", event)
        panda.onNext(event)
    }
    func hamsterSends(_ event: String) {
        printEventSent("🐹", event)
        hamster.onNext(event)
    }
    panda.concat(hamster)
        .subscribe(onNext: {
            receivedOrder.append($0)
            printEventReceived("🌝", $0)
        })
        .addDisposableTo(bag)
    
    pandaSends("⚽")
    pandaSends("🏀")
    hamsterSends("🌕")
    hamsterSends("🌗")
    pandaSends("🏈")
    panda.onCompleted()
    print("🐼 completed")
    hamsterSends("🌑")
    print("Received order: ", receivedOrder)
}

/*:
 ## Reduce
 Applies a funcion sequentially but emits only after reaching the final value
 
 ![Reduce](reduce.png)
 
 > Differently from `Scan`, it will emit only when it reaches the **last succession**
 
 */
example("Reduce") {
    let bag = DisposeBag()
    Observable.of("🌖","🌗","🌘","🌑")
        .reduce("🌕") { $0 + $1 }
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
}


/*: 
 ## To Array
 Converts a sequence into an array and emits a single event containing it **must be finite or it won't be called**
 
![To Array](to_array.png)
*/
example("To Array") {
    let bag = DisposeBag()
    Observable.from(0...9)
        .toArray()
        .subscribe { print($0) }
        .addDisposableTo(bag)
}

/*:
 ----
 [< Previous](@previous) |
 [Next >](@next)
 */
