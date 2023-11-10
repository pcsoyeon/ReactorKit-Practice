//
//  PhotoRouter.swift
//  Photo
//
//  Created by 김소연 on 11/10/23.
//

import RIBs

protocol PhotoInteractable: Interactable {
    var router: PhotoRouting? { get set }
    var listener: PhotoListener? { get set }
}

protocol PhotoViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PhotoRouter: ViewableRouter<PhotoInteractable, PhotoViewControllable>, PhotoRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PhotoInteractable, viewController: PhotoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
