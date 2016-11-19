/*:
 # Transforming Observables
 Operators that **transform items** that are emitted by an `Observable`
 */
import Foundation
import RxSwift

/*:
 # Buffer
 Periodically gathers items emmited by an `observable` then emits a bundle of them as a *single event*
 
 > In case of error, even if with a complete buffer, it will emit the error immediately
 
 ![Buffer](transform_buffer.png)
 */
example("Buffer") {
    let bag = DisposeBag()
    Observable.of("0️⃣","1️⃣","2️⃣","3️⃣","4️⃣","5️⃣","6️⃣","7️⃣","8️⃣","9️⃣","🔟")
        .buffer(timeSpan: 0.4, count: 3, scheduler: MainScheduler.instance)
        .subscribe(onNext: { printEventReceived("🦁", $0) })
        .addDisposableTo(bag)
}
/*:
 # Map
 Transforms the items emitted by an `Observable` by *applying a function* to each item
 
 **`f(a) -> b`**
 
 ![Map](transform_map.png)
 */
example("map") {
    let bag = DisposeBag()
    Observable.of("⚽️","🏀","🏈")
        .map { $0 + $0 }
        .subscribe(onNext: { printEventReceived("🦁", $0) })
        .addDisposableTo(bag)
}

/*:
 # Flat Map
 Transforms the elements emitted by and observable sequence into observable sequences
 
 Then flattens the emissions to a single `Observable`
 
 ![Flat Map](transform_flatmap.png)

 > If using `latest`, it will effectively become a `switch`
 
 */
example("Flat Map (latest)") {
    let bag = DisposeBag()
    struct Player {
        var score: Variable<Int>
    }
    
    let p1 = Player(score: Variable(1))
    let p2 = Player(score: Variable(10))
    let player = Variable(p
        
        player.asObservable()
//            .flatMapLatest { $0.score.asObservable() } //change to this and see how it behaves
            .flatMap { $0.score.asObservable() }
            .subscribe(onNext: { print($0) })
            .addDisposableTo(bag)
        p1.score.value = 2
        p1.score.value = 3
        player.value = p2
        p1.score.value = 4 // not emitted when using flatMapLatest
        p2.score.value = 12
}


/* 
 ## Scan
 Applies a function sequentially and emits each successive value
 
 ![Scan](transform_scan.png)
 */
example("scan") {
    let bag = DisposeBag()
    
    Observable.of(10, 100, 1000)
        .scan(1) { result, value in
            result + value }
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
}

/* 
 ## Reduce
 Applies a funcion sequentially but emits only after reaching the final value 
 
 ![Reduce](transform_reduce.png)
 */
example("reduce") {
    let bag = DisposeBag()
    
    Observable.of(1,3,5,8)
        .reduce(0) { result, value in
            result + value }
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
}

/*:
 ----
 [< Previous](@previous) |
 [Next >](@next)
 */
