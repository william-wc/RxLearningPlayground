import Foundation
import RxSwift

public class ActiveViewController {
    public enum Action {
        case refresh, redeem, openTransaction, openGroup
    }
    
    public let actionSubject = PublishSubject<Action>()
    public var actionObservable: Observable<Action> {
        return actionSubject.asObservable()
    }
    
    private(set) var viewModel: ActiveViewModel?
    
    public func bind(_ viewModel: ActiveViewModel) {
        self.viewModel = viewModel
    }
}
