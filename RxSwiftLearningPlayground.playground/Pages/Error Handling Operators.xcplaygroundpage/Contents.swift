/*:
 # Error Handling
 Operators that help to recover from error notifications from an `Observable`
 
 >
 */
import Foundation
import RxSwift
/*:
 ## Catch
 Intercepts an `onError` notification and *instead of passing* to observers, replaces it with some other item (or sequence) potentially allowing the `Observable` to terminate normally (or not)
 > catchError { }
 >
 > catchErrorJustReturn(Element)
 
 ![Catch](catch.png)
 
 */
example("Catch") {
    let bag = DisposeBag()
    Observable
        .create { (observer: AnyObserver<String>) -> Disposable in
            observer.onNext("🌕")
            observer.onNext("🌖")
            observer.onNext("🌗")
            observer.onNext("🌘")
            observer.onError(CelestialBodyCycleError.thatsNoMoon)
            return Disposables.create()
        }
        /* Comment out one of the catch cases */
        // Simplest error case, returns an immediate response
//        .catchErrorJustReturn("🌑") 
        
        // More flexible error case
        .catchError { e in
            return Observable.just("🌑")
        }
        .subscribe { printEventReceived("🐙", $0) }
        .addDisposableTo(bag)
}


/*:
 ## Retry
 If a source `Observable` emits an error, resubscribe to it in the hope that it will complete without error
 
 ![Retry](retry.png)
 */
example("Retry") {
    let bag = DisposeBag()
    var retryCount = 0
    Observable
        .create { (observer: AnyObserver<String>) -> Disposable in
            observer.onNext("🌕")
            observer.onNext("🌖")
            observer.onNext("🌗")
            observer.onNext("🌘")
            if retryCount == 0 {
                print("Error sent 🌝")
                observer.onError(CelestialBodyCycleError.thatsNoSun)
            } else {
                // in case of errors, explicit completions are needed to finish the Observable
                observer.onCompleted()
            }
            retryCount += 1
            return Disposables.create()
        }
        .retry()
        .subscribe { printEventReceived("🐱", $0) }
        .addDisposableTo(bag)
}


/*:
 ----
 [< Previous](@previous) |
 [Next >](@next)
 */
