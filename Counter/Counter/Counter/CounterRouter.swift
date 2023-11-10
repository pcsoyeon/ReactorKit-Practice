//
//  CounterRouter.swift
//  Counter
//
//  Created by 김소연 on 11/10/23.
//

import RIBs

protocol CounterInteractable: Interactable {
    var router: CounterRouting? { get set }
    var listener: CounterListener? { get set }
}

protocol CounterViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CounterRouter: ViewableRouter<CounterInteractable, CounterViewControllable>, CounterRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CounterInteractable, viewController: CounterViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
