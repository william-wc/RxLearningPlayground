/*:
 # Filtering Observables
 Operators that selectively emit items from a source `Observable`
*/
import Foundation
import RxSwift
/*:
 # Debounce
 Only emits an item from an `Observable` if a certain timespan has passed without it sending another item
 
 ![Debounce](debounce.png)
 
 */
example("Debounce") {
    let bag = DisposeBag()
    // TODO change Scheduler
    Observable
        .create { (observer: AnyObserver<String>) -> Disposable in
            observer.onNext("a")
            Thread.sleep(forTimeInterval: 0.5)
            observer.onNext("b")
            observer.onNext("c")
            Thread.sleep(forTimeInterval: 0.2)
            observer.onNext("d")
            return Disposables.create()
        }
        .debounce(0.1, scheduler: ConcurrentMainScheduler.instance)
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
}

/*:
 # Distinct
 Supresses duplicates items already emitted
 
 ![Distinct](distinct.png)
 
 */
example("Distinct") {
    let bag = DisposeBag()
    Observable.of("⚽","⚽","🏀","⚽","🏈","🏈","🏈","🏐","🏐")
        .distinctUntilChanged()
        .subscribe { printEventReceived("🐹", $0) }
        .addDisposableTo(bag)
}

/*:
 # Filter
 Emit only items that pass the predicate test
 
 ![Filter](filter.png)
 
 */
example("Filter") {
    let bag = DisposeBag()
    Observable.of("⚽","🏀","🏈","🎾","🏐","🏉")
        .filter { $0 == "🏐" || $0 == "🎾" }
        .subscribe { printEventReceived("🐹", $0) }
        .addDisposableTo(bag)
}

/*:
 # IgnoreElements
 Ignores emissions of items, but sends the termination notification (**`Error or Completion`**)
 
 ![IgnoreElements](ignore_elements.png)
 
 */
example("Ignore Elements") {
    let bag = DisposeBag()
    Observable.of("⚽","🏀","🏈","🎾","🏐","🏉")
        .ignoreElements()
        .subscribe { printEventReceived("🐹", $0) }
        .addDisposableTo(bag)
}

/*:
 # Sample
 Emit only the last item emitted by the source `Observable`
 
 ![Sample](sample.png)
 
 */
example("Sample") {
    let bag = DisposeBag()
    // Todo
}

/*:
 # Single
 Emits only if there is *exactly* one item
 
 Or if the predicate filters *exactly* one item
 
 */
example("Single") {
    let bag = DisposeBag()
    // Single with only one item
    Observable.of("⚽")
        .single()
        .subscribe { printEventReceived("🐹", $0) }
        .addDisposableTo(bag)
    // Single with multiple items
    Observable.of("⚽","🏀","🏈","🎾","🏐","🏉")
        .single()
        .subscribe { printEventReceived("🐹", $0) }
        .addDisposableTo(bag)
    // Single that filters only one item
    Observable.of("⚽","🏀","🏈","🎾","🏐","🏉")
        .single { $0 == "🏀" }
        .subscribe { printEventReceived("🐹", $0) }
        .addDisposableTo(bag)
    // Single that filters multiple items
    Observable.of("⚽","🏀","🏈","🎾","🏐","🏉")
        .single { $0 == "🏀" || $0 == "🏐" }
        .subscribe { printEventReceived("🐹", $0) }
        .addDisposableTo(bag)
}

/*:
 # ElementAt
 Emits only the nᵗʰ item
 
 ![ElementAt](element_at.png)
 
 */
example("Element At") {
    let bag = DisposeBag()
    Observable.of("⚽","🏀","🏈","🎾","🏐","🏉")
        .elementAt(3)
        .subscribe { printEventReceived("🐹", $0) }
        .addDisposableTo(bag)
}

/*:
 # Skip / SkipUntil / SkipWhile
 Supresses the first *n* items
 
 ![Skip](skip.png)
 
 */
example("Skip") {
    let bag = DisposeBag()
    Observable.of("⚽","🏀","🏈","🎾","🏐","🏉")
        .skip(3)
        .subscribe { printEventReceived("🐹", $0) }
        .addDisposableTo(bag)
}

/*:
 # Take / TakeUntil / TakeWhile
 Emits only the first *n* items
 
 ![Take](take.png)
 
 */
example("Take") {
    let bag = DisposeBag()
    Observable.of("⚽","🏀","🏈","🎾","🏐","🏉")
        .take(5)
        .subscribe { printEventReceived("🐹", $0) }
        .addDisposableTo(bag)
}

/*:
 # TakeLast
 Emits only the last *n* items *in emission order* (items before the termination notification)
 
 ![TakeLast](take_last.png)
 
 */
example("Take Last") {
    let bag = DisposeBag()
    Observable.of("⚽","🏀","🏈","🎾","🏐","🏉")
        .takeLast(3)
        .subscribe { printEventReceived("🐹", $0) }
        .addDisposableTo(bag)
}


/*:
 ----
 [< Previous](@previous) |
 [Next >](@next)
 */
