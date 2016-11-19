
//: # Filtering

import Foundation
import RxSwift

/* Only emits if a certain timespan has passed without it emitting another item, 
 and always the last item (for that time frame) */
example("Debounce") {
    let bag = DisposeBag()
    Observable.of(0,1,2,3,4,5)
        .debounce(0.2, scheduler: MainScheduler.instance)
        .subscribe { print($0) }
        .addDisposableTo(bag)
}

/* Emits only when condition is satisfied */
example("filter") {
    let bag = DisposeBag()
    Observable.from(0...9)
        .filter { $0 % 2 == 0 }
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
}

/* Emits only when the value is different from the previous one */
example("distinct until changed") {
    let bag = DisposeBag()
    Observable.of(0,0,1,1,1,2,3,3,4)
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
}

/* Emits the element picked at a certain position / index */
example("element at") {
    let bag = DisposeBag()
    Observable.from(0...9)
        .elementAt(5)
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
}

/* Emits only the first element 
 throws error if there is not exactly one event */
example("single") {
    let bag = DisposeBag()
    Observable.of(1,2,3)
        .single()
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
}

/* Emits only the first element which meets the condition
 throws error if there is not exactly one event */
example("single with condition") {
    let bag = DisposeBag()
    Observable.from(0...9)
        .single { $0 == 9 }
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
}

/* 
 Skips the first elements that meet the condition 
 SkipLast()
 Take()
 TakeLast()
 */
example("observer repeat element") {
    let bag = DisposeBag()
    Observable.repeatElement("Just")
        .take(5)
        .subscribe { print($0) }
        .addDisposableTo(bag)
}

example("skip") {
    let bag = DisposeBag()
    Observable.from(0...9)
        .skip(4)
        .subscribe(onNext: { print($0) })
        .addDisposableTo(bag)
}
