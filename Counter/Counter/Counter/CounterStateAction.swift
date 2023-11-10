//
//  CounterStateAction.swift
//  Counter
//
//  Created by 김소연 on 11/10/23.
//

import ReactorKit

enum CounterAction {
    case increaseButtonTap
    case decreaseButtonTap
}

struct CounterState {
    var value: Int
    var isLoading: Bool
    @Pulse var alertMessage: String?
}

protocol CounterPresentableListener: AnyObject {
    func increase()
    func decrease()
    
    typealias State = CounterState
    var state: Observable<State> { get }
}
