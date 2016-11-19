
//: # Mathematical and Aggregate Operators

import Foundation
import RxSwift


//: ## Concat
//: ### Concatenates the elements in a sequential manner, waiting for each sequence to terminate before emiting the next one's values
example("Concat") {
    let bag = DisposeBag()
    var sentA = ["🌱","🎄","🌲","🌳"]
    var sentB = ["🌚","🌑","🌓","🌕"]
    var receivedOrder = [String]()
    let a = BehaviorSubject(value: "🌱")
    let b = BehaviorSubject(value: "🌚")
    let variable = Variable(a)
    
    variable.asObservable()
        .concat()
        .subscribe(onNext: { receivedOrder.append($0) })
        .addDisposableTo(bag)
    a.onNext(sentA[1])
    a.onNext(sentA[2])
    b.onNext(sentB[1])  // this value is ignored, since it's not the focused subject
    variable.value = b  // from this point ownward, the values from B will be registered
    b.onNext(sentB[2])
    a.onNext(sentA[3])  // even though the variable changed, it will still recognize A until completed
    a.onCompleted()
    b.onNext(sentB[3])
    
    print("Sent from A   : ", sentA)
    print("Sent from B   : ", sentB)
    print("Received order: ", receivedOrder)
}


//: ## Count

//: ## Min / Max

//: ## Reduce

//: ## Sum

//: ## Average

//: ## To Array
//: ### Converts a sequence into an array and emits a single event containing it **must be finite or it won't be called**
example("to array") {
    let bag = DisposeBag()
    Observable.from(0...9)
        .toArray()
        .subscribe { print($0) }
        .addDisposableTo(bag)
}


//: [Next](@next)
//: [Previous](@previous)