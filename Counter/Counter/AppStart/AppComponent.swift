//
//  AppComponent.swift
//  Counter
//
//  Created by 김소연 on 11/10/23.
//

import RIBs

final class AppComponent: Component<EmptyComponent>, CounterDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}

