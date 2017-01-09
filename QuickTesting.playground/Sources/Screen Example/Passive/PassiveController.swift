import Foundation
import RxSwift

public class PassiveController {
    
    let disposeBag = DisposeBag()
    let viewController: PassiveViewController
    
    init(state: Observable<State>,
         group: Observable<Group?>) {
        self.viewController = PassiveViewController()
        
        Observable
            .combineLatest(state, group) { $0 }
            .distinctUntilChanged { $0.0.0 == $0.1.0 }
            .subscribe(onNext: { [weak self] (state, group) in
                let vm = PassiveViewModel(state: state, group: group)
                self?.viewController.bind(vm)
            })
            .addDisposableTo(disposeBag)
    }
}
