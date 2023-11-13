//
//  RepoSearchStateAction.swift
//  GithubSearch
//
//  Created by 김소연 on 11/13/23.
//

import Foundation

import ReactorKit
import RIBs

struct RepoSearchState {
    var query: String?
    var repos: [String] = []
    var nextPage: Int?
    var isLoadingNextPage: Bool = false
}

enum RepoSearchAction {
    case updateQuery(String?)
    case loadNextPage
}

protocol RepoSearchPresentableListener: AnyObject {
    func updateQuery(query: String?)
}
