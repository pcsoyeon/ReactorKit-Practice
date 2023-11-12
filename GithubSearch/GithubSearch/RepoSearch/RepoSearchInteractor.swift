//
//  RepoSearchInteractor.swift
//  GithubSearch
//
//  Created by 김소연 on 11/13/23.
//

import RIBs
import RxSwift

protocol RepoSearchRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RepoSearchPresentable: Presentable {
    var listener: RepoSearchPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RepoSearchListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RepoSearchInteractor: PresentableInteractor<RepoSearchPresentable>, RepoSearchInteractable, RepoSearchPresentableListener {

    weak var router: RepoSearchRouting?
    weak var listener: RepoSearchListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RepoSearchPresentable) {
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
