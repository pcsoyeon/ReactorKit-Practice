//
//  SearchRouter.swift
//  GithubSearch
//
//  Created by 김소연 on 11/10/23.
//

import RIBs

protocol SearchInteractable: Interactable {
    var router: SearchRouting? { get set }
    var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SearchInteractable, viewController: SearchViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
