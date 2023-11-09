//
//  CounterReactor.swift
//  Counter
//
//  Created by 김소연 on 11/9/23.
//

import ReactorKit

final class CounterReactor: Reactor {
    
    enum Action {
        case increase
        case decrease
    }
    
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
        case setAlertMessage(String)
    }
    
    struct State {
        var value: Int
        var isLoading: Bool
        @Pulse var alertMessage: String?
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(
            value: 0, // start from 0
            isLoading: false
        )
    }
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setAlertMessage("Increased"))
            ])
        case .decrease:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setAlertMessage("Decreased"))
            ])
        }
    }
    
    // Mutation -> State
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
