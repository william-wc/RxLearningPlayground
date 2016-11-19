import Foundation
import UIKit
import RxSwift

/*
 Observers: 
 🐔🐸🐙🐶🐱🐹🐼🦁
 🌚🌝
 Events:
 🌕🌖🌗🌘🌑🌒🌓🌔
 ⚽️🏀🏈⚾️🎾🏐🏉
 0️⃣1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟
 */

/* Simple container for executing separate executions within a group/closure */
public func example(_ name: String, action: @escaping () -> ()) {
    print("=======================================")
    print("  \(name)")
    print("=======================================")
    action()
    print("\n\n")
}

public enum RxLearningError: Error {
    case doIt
}

/* Creates a simple observer that fires it's contents between an interval */
public func makeObserver<E>(interval: TimeInterval, contents: [E]) -> Observable<E> {
    return Observable.create({ (observer) -> Disposable in
        let timer = DispatchSource.makeTimerSource()
        timer.scheduleRepeating(deadline: DispatchTime.now(), interval: interval)
        
        // Method called when the DisposeBag containing this observer is deinitialized
        let cancel = Disposables.create {
            timer.cancel()
        }
        
        var it = contents.makeIterator()
        timer.setEventHandler(handler: {
            guard
                let element = it.next(),
                !cancel.isDisposed
                else {
                    observer.onCompleted()
                    return
            }
            observer.onNext(element)
        })
        timer.resume()
        return cancel
    })
}

public func printSubscribed(_ value: Any) {
    print("\(value) << subscribed")
}

public func printEventSent(_ value: Any) {
    print(">> \(value) sent")
}

public func printEventReceived(_ subscriber: String, _ event: Any) {
    print("\(subscriber) << \(event)")
}

public var currentTimeStamp: String {
    let date = Date()
    let calendar = Calendar.current
    let hour    = calendar.component(.hour, from: date)
    let min     = calendar.component(.minute, from: date)
    let second  = calendar.component(.second, from: date)
    let nanosec = calendar.component(.nanosecond, from: date)
    return "\(hour):\(min):\(second) \(nanosec)"
}
