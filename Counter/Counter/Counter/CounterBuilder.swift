//
//  CounterBuilder.swift
//  Counter
//
//  Created by 김소연 on 11/10/23.
//

import RIBs

protocol CounterDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CounterComponent: Component<CounterDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CounterBuildable: Buildable {
    func build() -> LaunchRouting
}

final class CounterBuilder: Builder<CounterDependency>, CounterBuildable {

    override init(dependency: CounterDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let component = CounterComponent(dependency: dependency)
        let viewController = CounterViewController()
        let interactor = CounterInteractor(
            presenter: viewController,
            initialState: CounterState.init(value: 0, isLoading: false)
        )
        
        return LaunchRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
