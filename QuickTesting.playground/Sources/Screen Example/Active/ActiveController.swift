import Foundation
import RxSwift

public class ActiveController {
    
    public let viewController: ActiveViewController
    public let disposeBag = DisposeBag()
    
    public var actionObservable: Observable<ActiveViewController.Action> {
        return viewController.actionObservable
    }
    
    init(state: Observable<State>,
         enrollment: Observable<Enrollment>,
         events: Observable<[Event]>,
         group: Observable<Group?>) {
        
        self.viewController = ActiveViewController()
        
        Observable
            .combineLatest(state, events) { s, e -> State in
                switch (s, e.isEmpty) {
                case (.loading, true): return .loading
                default: return s
                }
            }
            .subscribe(onNext: { state in
                let vm = ActiveViewModel(state: state)
                self.viewController.bind(vm)
            })
            .addDisposableTo(disposeBag)
    }
}
