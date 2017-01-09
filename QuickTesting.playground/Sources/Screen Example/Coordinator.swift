import Foundation
import RxSwift

public class Coordinator {
    //
    public var screens: [ScreenController] = []
    public var bag = DisposeBag()
    
    //
    public let state = Variable<State>(.loading)
    public let group = Variable<Group?>(nil)
    public let enrollment = Variable<Enrollment>(Enrollment())
    public let events = Variable<[Event]>([])
    
    // 
    public init() {
        act("Coordinator \(#function)")
    }
    
    public func presentScreen() {
        act("Coordinator \(#function)")
        let screen = ScreenController(
            state: state.asObservable(),
            enrollment: enrollment.asObservable(),
            group: group.asObservable(),
            events: events.asObservable()
        )
        
        screen.resultObservable
            .debug("Coordinator Screen-Result", trimOutput: true)
            .subscribe(onNext: { _ in
                self.test()
            })
            .addDisposableTo(screen.disposeBag)
        screens.append(screen)
    }
    
    func test() {
        print("testing")
    }
    
    public func popScreen() {
        _ = screens.popLast()
    }
    
    public func cleanBag() {
        bag = DisposeBag()
    }
    
    deinit {
        print("--- Coordinator dying ---")
    }
}
