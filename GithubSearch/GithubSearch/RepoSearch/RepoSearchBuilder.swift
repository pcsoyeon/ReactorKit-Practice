//
//  RepoSearchBuilder.swift
//  GithubSearch
//
//  Created by 김소연 on 11/13/23.
//

import RIBs

protocol RepoSearchDependency: Dependency {
    var repoSearchRepository: RepoSearchRepository { get }
}

final class RepoSearchComponent: Component<RepoSearchDependency> {
    fileprivate var initialState: RepoSearchState {
        RepoSearchState()
    }
}

// MARK: - Builder

protocol RepoSearchBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RepoSearchBuilder: 
    SimpleComponentizedBuilder<RepoSearchComponent, LaunchRouting>,
    RepoSearchBuildable
{

    override func build(with component: RepoSearchComponent) -> LaunchRouting {
        let viewController = RepoSearchViewController()
        let interactor = RepoSearchInteractor(
            presenter: viewController,
            initialState: component.initialState,
            repository: component.dependency.repoSearchRepository
        )
        
        return LaunchRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
    
}
