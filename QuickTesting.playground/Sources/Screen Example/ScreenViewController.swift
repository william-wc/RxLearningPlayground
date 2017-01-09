import Foundation
import RxSwift

public class ScreenViewController {
    
    public let navigationSubject = PublishSubject<NavigationAction>()
    public var navigationObservable: Observable<NavigationAction> {
        return navigationSubject.asObservable()
    }
    
    private(set) var viewModel: ScreenViewModel?
    
    public func bind(_ viewModel: ScreenViewModel) {
        self.viewModel = viewModel
        
    }
}
