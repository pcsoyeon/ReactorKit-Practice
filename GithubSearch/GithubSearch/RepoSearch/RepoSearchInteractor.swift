//
//  RepoSearchInteractor.swift
//  GithubSearch
//
//  Created by 김소연 on 11/13/23.
//

import Foundation

import Alamofire
import RIBs
import RxSwift
import RxCocoa
import ReactorKit

protocol RepoSearchRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RepoSearchPresentable: Presentable {
    var listener: RepoSearchPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RepoSearchListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RepoSearchInteractor:
    PresentableInteractor<RepoSearchPresentable>,
    RepoSearchInteractable,
    RepoSearchPresentableListener,
    Reactor
{
    
    // MARK: - RepoSearch Reactor
    
    typealias Action = RepoSearchAction
    typealias State = RepoSearchState
    
    enum Mutation {
        case setQuery(String?)
        case setRepos([String], nextPage: Int?)
        case appendRepos([String], nextPage: Int?)
        case setLoadingNextPage(Bool)
    }
    var initialState: RepoSearchState
    
    // MARK: - Properties
    
    weak var router: RepoSearchRouting?
    weak var listener: RepoSearchListener?
    
    // MARK: - Initializer
    
    init(
        presenter: RepoSearchPresentable,
        initialState: RepoSearchState
    ) {
        self.initialState = initialState
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - RepoSearchPresentableListener
    
    func updateQuery(query: String?) {
        self.action.on(.next(.updateQuery(query)))
    }
    
}

extension RepoSearchInteractor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateQuery(let query):
            return Observable.concat([
                Observable.just(Mutation.setQuery(query)),
                self.search(query: query, page: 1)
                    .take(until: self.action.filter(isUpdateQueryAction(_:)))
                    .map { Mutation.setRepos($0, nextPage: $1) }
            ])
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                self.search(query: self.currentState.query, page: page)
                    .take(until: self.action.filter(isUpdateQueryAction(_:)))
                    .map { Mutation.appendRepos($0, nextPage: $1) },
                Observable.just(Mutation.setLoadingNextPage(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setQuery(query):
            newState.query = query
            
        case let .setRepos(repos, nextPage: nextPage):
            newState.repos = repos
            newState.nextPage = nextPage
            
        case let .appendRepos(repos, nextPage: nextPage):
            newState.repos.append(contentsOf: repos)
            newState.nextPage = nextPage
            
        case let .setLoadingNextPage(isLoadingNextPage):
            newState.isLoadingNextPage = isLoadingNextPage
        }
        return newState
    }
    
    private func url(for query: String?, page: Int) -> URL? {
        guard let query = query, !query.isEmpty else { return nil }
        return URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
    }
    
    private func search(query: String?, page: Int) -> Observable<(repos: [String], nextPage: Int?)> {
        let emptyResult: ([String], Int?) = ([], nil) // 실패했을 때 내보낼 결과
        guard let url = self.url(for: query, page: page) else { return Observable.just(emptyResult) }
        return URLSession.shared.rx.json(url: url)
            .map { json -> ([String], Int?) in
                guard let dictionary = json as? [String: Any] else { return emptyResult }
                guard let items = dictionary["items"] as? [[String: Any]] else { return emptyResult }
                let repos = items.compactMap { $0["full_name"] as? String }
                let nextPage = repos.isEmpty ? nil : page + 1
                return (repos, nextPage)
            }
        .do(onError: { error in
            if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError, response.statusCode == 403 {
                print("Github API rate limit exceeded.")
            }
        })
        .catchAndReturn(emptyResult)
        
    }
    
    func isUpdateQueryAction(_ action: RepoSearchAction) -> Bool {
        if case .updateQuery = action {
            return true
        } else {
            return false
        }
    }
    
}
