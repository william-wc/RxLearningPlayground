import Foundation
import RxSwift

public struct ScreenViewModel {
    public let activeController: ActiveController
    public let passiveController: PassiveController
}

extension ScreenViewModel {
    public init(state: Observable<State>,
                enrollment: Observable<Enrollment>,
                events: Observable<[Event]>,
                group: Observable<Group?>) {
        activeController = ActiveController(state: state,
                                            enrollment: enrollment,
                                            events: events,
                                            group: group)
        passiveController = PassiveController(state: state,
                                              group: group)
    }
}
