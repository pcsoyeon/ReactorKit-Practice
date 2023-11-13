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
    private let repository: RepoSearchRepository
    
    // MARK: - Properties
    
    weak var router: RepoSearchRouting?
    weak var listener: RepoSearchListener?
    
    // MARK: - Initializer
    
    init(
        presenter: RepoSearchPresentable,
        initialState: RepoSearchState,
        repository: RepoSearchRepository
    ) {
        self.initialState = initialState
        self.repository = repository
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
                self.repository.search(query: query, page: 1)
                    .take(until: self.action.filter(isUpdateQueryAction(_:)))
                    .map { Mutation.setRepos($0, nextPage: $1) }
            ])
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                self.repository.search(query: self.currentState.query, page: page)
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
    
    func isUpdateQueryAction(_ action: RepoSearchAction) -> Bool {
        if case .updateQuery = action {
            return true
        } else {
            return false
        }
    }
    
}
