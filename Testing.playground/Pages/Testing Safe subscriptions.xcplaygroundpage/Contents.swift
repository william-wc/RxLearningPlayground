import Foundation
import RxSwift

protocol BagHolder: class {
    var disposeBag: DisposeBag { get set }
}
extension BagHolder {
    func clearBag() {
        self.disposeBag = DisposeBag()
    }
}

//////
protocol ResultExposer {
    associatedtype Result
    var resultObservable: Observable<Result> { get }
}

extension ResultExposer where Self: BagHolder, Self: Deinitable {
    func safeSub(_ on: @escaping (Event<Result>) -> Void) {
        resultObservable
            .debug(self.identifier)
            .subscribe(on)
            .addDisposableTo(disposeBag)
    }
    
    func safeSubscribe<T: ObservableType>(_ observable: T,
                       onNext:((Self)->((T.E)->Void))? = nil,
                       onError:((Self)->((Error)->Void))? = nil,
                       onCompleted:((Self)->((Void)->Void))? = nil) {
        observable
            .subscribe(onNext: { [unowned self] in onNext?(self)($0) },
                       onError: { [unowned self] in onError?(self)($0) },
                       onCompleted: { [unowned self] in onCompleted?(self)($0) })
            .addDisposableTo(disposeBag)
    }
}

//////
protocol ResultSender {
    associatedtype Result
    var resultSubject: PublishSubject<Result> { get }
}
extension ResultSender {
    func send(_ e: Event<Result>) { resultSubject.on(e) }
}

//////
protocol ResultSubscriber: BagHolder {
    associatedtype Result
}
extension ResultSubscriber where Self: Deinitable {
    func sub(_ o: Observable<Result>) {
        o.debug(identifier)
            .subscribe { self.doNothing($0) }
//            .subscribe { [weak self] in self?.doNothing($0) }
            .addDisposableTo(disposeBag)
    }
    
    func subSafe<R: ResultExposer>(_ o: R) where R: BagHolder, R: Deinitable {
        o.safeSub { self.doNothing($0) }
//        o.safeSub { [weak self] in self?.doNothing($0) }
    }
    
    func doNothing(_ obj: Any? = nil) {}
}

//////
protocol ResultBinder: ResultSender, BagHolder {}
extension ResultBinder where Self : Deinitable {
    func bind(_ o: Observable<Result>) {
        o.debug(identifier)
            .subscribe(resultSubject)
            .addDisposableTo(disposeBag)
    }
}

//////
protocol ResultLinker: ResultExposer, ResultSender, ResultSubscriber, ResultBinder, BagHolder {}
extension ResultLinker {
    var resultObservable: Observable<Self.Result> {
        return resultSubject.asObservable()
    }
}

//////
class Deinitable {
    private(set) var identifier: String
    
    init(_ identifier: String? = nil) {
        // workaround for 
        // self.identifier = identifier ?? String(describing: type(of: self))
        if let identifier = identifier {
            self.identifier = identifier
        } else {
            self.identifier = String(describing: type(of: self))
        }
        print(" ++ init \(self.identifier) ++")
    }
    
    deinit {
        print(" ++ deinit \(identifier) ++ ")
    }
}

// ---- Implementations
enum Answer {
    case yes, no, maybe
}

class A: Deinitable, ResultLinker {
    typealias Result = Answer

    var resultSubject = PublishSubject<Answer>()
    var disposeBag = DisposeBag()
}

class B: Deinitable, ResultSubscriber {
    typealias Result = Answer

    var disposeBag = DisposeBag()
    func doNothing() {}
}

// ---- Executions
with {
    var a = Optional.some(A())
    var b = Optional.some(B())
    
    b?.sub(a!.resultObservable)
//    b?.subSafe(a!)
    
    a?.send(.next(.maybe))
    
    a = nil
    print("do something else ")
    b?.doNothing()
}

with { return
    var a = Optional.some(A())
    var aa = Optional.some(A("AA"))
    var b = Optional.some(B())
    a?.bind(aa!.resultSubject)
    b?.sub(a!.resultObservable)
    
    aa?.send(.next(.yes))
    a?.send(.next(.no))

    print(" == A = nil ==")
    a = nil
    
    print(" == AA = nil ==")
    aa = nil
    
    b?.clearBag()
}
