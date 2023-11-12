//
//  RepoSearchRouter.swift
//  GithubSearch
//
//  Created by 김소연 on 11/13/23.
//

import RIBs

protocol RepoSearchInteractable: Interactable {
    var router: RepoSearchRouting? { get set }
    var listener: RepoSearchListener? { get set }
}

protocol RepoSearchViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RepoSearchRouter: ViewableRouter<RepoSearchInteractable, RepoSearchViewControllable>, RepoSearchRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RepoSearchInteractable, viewController: RepoSearchViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
