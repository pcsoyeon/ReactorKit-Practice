//
//  CounterInteractor.swift
//  Counter
//
//  Created by 김소연 on 11/10/23.
//

import ReactorKit
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

final class CounterInteractor:
    PresentableInteractor<CounterPresentable>,
    CounterInteractable,
    CounterPresentableListener,
    Reactor
{

    // MARK: - Counter Reactor
    
    typealias Action = CounterAction
    typealias State = CounterState
    
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
        case setAlertMessage(String)
    }
    
    var initialState: CounterState
    
    // MARK: - Properties
    
    weak var router: CounterRouting?
    weak var listener: CounterListener?

    init(
        presenter: CounterPresentable,
        initialState: CounterState
    ) {
        self.initialState = initialState
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - CounterPresentableListener
    
    func increase() {
        self.action.on(.next(.increaseButtonTap))
    }
    
    func decrease() {
        self.action.on(.next(.decreaseButtonTap))
    }
    
}

extension CounterInteractor {
    
    func mutate(action: CounterAction) -> Observable<Mutation> {
        switch action {
        case .increaseButtonTap:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setAlertMessage("Increased"))
            ])
        case .decreaseButtonTap:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setAlertMessage("Decreased"))
            ])
        }
    }
    
}

extension  CounterInteractor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .increaseValue:
            state.value += 1
        case .decreaseValue:
            state.value -= 1
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setAlertMessage(let message):
            state.alertMessage = message
        }
        return state
    }
    
}

