//
//  PhotoInteractor.swift
//  Photo
//
//  Created by 김소연 on 11/10/23.
//

import RIBs
import RxSwift

protocol PhotoRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PhotoPresentable: Presentable {
    var listener: PhotoPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol PhotoListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class PhotoInteractor: PresentableInteractor<PhotoPresentable>, PhotoInteractable, PhotoPresentableListener {

    weak var router: PhotoRouting?
    weak var listener: PhotoListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PhotoPresentable) {
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
