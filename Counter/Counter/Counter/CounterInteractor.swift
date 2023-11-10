//
//  CounterInteractor.swift
//  Counter
//
//  Created by 김소연 on 11/10/23.
//

import RIBs
import RxSwift

protocol CounterRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CounterPresentable: Presentable {
    var listener: CounterPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CounterListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class CounterInteractor: PresentableInteractor<CounterPresentable>, CounterInteractable, CounterPresentableListener {

    weak var router: CounterRouting?
    weak var listener: CounterListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: CounterPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
