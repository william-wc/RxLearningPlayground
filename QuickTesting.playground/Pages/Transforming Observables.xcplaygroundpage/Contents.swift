/*:
 # Transforming Observables
 Operators that **transform items** that are emitted by an `Observable`
 */
import Foundation
import RxSwift

/*:
 ## Buffer
 Periodically gathers items emmited by an `observable` then emits a bundle of them as a *single event*
 
 > In case of error, even if with a complete buffer, it will emit the error immediately
 >
 > if `count` value breaks evenly the number of events emitted, it will send an **`empty valued event`**, then a **`completion event`**
 
 ![Buffer](buffer.png)
 */
example("Buffer") {
    let bag = DisposeBag()
    Observable.of("0️⃣","1️⃣","2️⃣","3️⃣","4️⃣","5️⃣","6️⃣","7️⃣","8️⃣","9️⃣")
        .buffer(timeSpan: 0.4,
                count: 5, //use different count values to see what happens
                scheduler: MainScheduler.instance)
        .subscribe { printEventReceived("🦁", $0) }
        .addDisposableTo(bag)
}

/*:
 ## Window
 Periodically subdivide items from an `Observable` into `Observable windows` and emit these windows
 
 > Similar to `Buffer`, but instead of sending a event with a *collection of items*, it sends an `Observable` of those elements
 >
 > If `count` value breaks evenly the number of events emitted, it will send an **`empty valued event`**, then a **`completion event`**
 
 ![Window](window.png)
 
 */
example("Window") {
    let bag = DisposeBag()
    Observable.of(0,1,2,3,4,5,6,7,8,9)
        .window(timeSpan: 0,
                count: 5, // Change the value of count and notice the final events
                scheduler: MainScheduler.instance)
        .subscribe { event in
            switch event {
            case .next(let window):
                print("-- Window --")
                window.subscribe { printEventReceived("🦁", $0) }
            case .error(let error):
                printErrorReceived("🦁", error)
            case .completed:
                print("-- No More Windows --")
            }
            
        }
        .addDisposableTo(bag)
}

/*:
 ## Map
 Transforms the items emitted by an `Observable` by *applying a function* to each item
 
 **`f(a) -> b`**
 
 ![Map](map.png)
 */
example("Map") {
    let bag = DisposeBag()
    Observable.of("⚽️","🏀","🏈")
        .map { $0 + $0 }
        .subscribe(onNext: { printEventReceived("🦁", $0) })
        .addDisposableTo(bag)
}

/*:
 ## Flat Map
 Transforms the elements emitted by and observable sequence into observable sequences
 
 Then flattens the emissions to a single `Observable`
 
 ![Flat Map](flatmap.png)

 > Note that `FlatMap` **merges** the emissions from these `Observables`, so they may *interleave*
 >
 > If using `latest`, it will effectively become a `switch`
 
 */
example("Flat Map") {
    let bag = DisposeBag()
    Observable.of("🎾","🏐","🏉")
        .flatMap { Observable.of($0,$0,$0) }
        .subscribe(onNext: { printEventReceived("🦁", $0) })
        .addDisposableTo(bag)
}


/*:
 ## Scan
 Applies a function sequentially and emits each successive value
 
 ![Scan](scan.png)
 
 > Differently from `Reduce`, it will emit for each **successful succession**
 
 */
example("Scan") {
    let bag = DisposeBag()
    Observable.of("1️⃣","2️⃣","3️⃣","4️⃣")
        .scan("0️⃣") { $0 + $1 }
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
}


/*:
 ----
 [< Previous](@previous) |
 [Next >](@next)
 */
