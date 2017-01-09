import Foundation
import RxSwift

public class ScreenController {
    public enum Result {
        case close, refresh, openTransaction, filter, redeem
    }
    
    public let disposeBag = DisposeBag()
    public let viewController: ScreenViewController
    public let resultSubject = PublishSubject<Result>()
    public var resultObservable: Observable<Result> {
        return resultSubject.asObservable()
    }
    
    public init(state: Observable<State>,
         enrollment: Observable<Enrollment>,
         group: Observable<Group?>,
         events: Observable<[Event]>) {
        act("Screen Controller \(#function)")
        self.viewController = ScreenViewController()
        
        let viewModel = ScreenViewModel(state: state,
                                        enrollment: enrollment,
                                        events: events,
                                        group: group)
        
        viewController.bind(viewModel)
        
        viewController.navigationObservable
            .debug("Screen Controller - Navigation", trimOutput: true)
            .map { _ in Result.close }
            .subscribe(resultSubject)
            .addDisposableTo(disposeBag)
        
        viewModel.activeController
            .actionObservable
            .debug("Screen Controller - Action", trimOutput: true)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .refresh:
                    self?.resultSubject.onNext(.refresh)
                case .openGroup:
                    self?.resultSubject.onNext(.filter)
                case .openTransaction:
                    self?.resultSubject.onNext(.openTransaction)
                case .redeem:
                    self?.resultSubject.onNext(.redeem)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    deinit {
        print("--- Screen Controller dying ---")
    }
}
