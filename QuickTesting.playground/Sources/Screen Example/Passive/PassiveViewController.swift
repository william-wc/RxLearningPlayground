import Foundation
import RxSwift

public class PassiveViewController {
    
    let disposeBag = DisposeBag()
    
    private(set) var viewModel: PassiveViewModel?
    
    
    public func bind(_ viewModel: PassiveViewModel) {
        self.viewModel = viewModel
    }
}
