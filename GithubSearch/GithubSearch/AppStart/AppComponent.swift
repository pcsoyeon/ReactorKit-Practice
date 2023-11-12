//
//  AppComponent.swift
//  GithubSearch
//
//  Created by 김소연 on 11/13/23.
//

import RIBs

final class AppComponent: Component<EmptyComponent>, RepoSearchDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}

