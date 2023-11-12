//
//  RepoSearchBuilder.swift
//  GithubSearch
//
//  Created by 김소연 on 11/13/23.
//

import RIBs

protocol RepoSearchDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RepoSearchComponent: Component<RepoSearchDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RepoSearchBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RepoSearchBuilder: Builder<RepoSearchDependency>, RepoSearchBuildable {

    override init(dependency: RepoSearchDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let component = RepoSearchComponent(dependency: dependency)
        let viewController = RepoSearchViewController()
        let interactor = RepoSearchInteractor(presenter: viewController)
        
        return LaunchRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
