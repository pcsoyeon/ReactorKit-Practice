//
//  GithubSearchReactor.swift
//  GithubSearch
//
//  Created by 김소연 on 11/10/23.
//

import Foundation

import Alamofire
import ReactorKit
import RxSwift
import RxCocoa

final class GithubSearchReactor: Reactor {
    
    /*
     Action
     = VC의 Action을 받아올 부분
     - updateQuery(String?) : VC의 searchController의 String을 받을 Action
     - loadNextPage : 사용자가 스크롤을 내려 더 많은 정보를 원할 때 다음 정보를 보여주기 위한 Action
     */
    enum Action {
        /// 검색
        case updateQuery(String?)
        /// 무한 스크롤
        case loadNextPage
    }
    
    /*
     Mutation
     - setQuery : query를 세팅하는 Mutation
     - setRepos : VC로 보여줄 repository를 세팅하는 Mutation
     - appendRepos : loadNextPage로 추가된 repository를 담는 Mutation
     - setLoadingNextPage : 다음 페이지가 로딩 중인지 아닌지
     */
    enum Mutation {
        /// 검색
        case setQuery(String?)
        /// 레포, 다음 페이지 (없을 수도 있기 때문에 옵셔널로)
        case setRepos([String], nextPage: Int?)
        case appendRepos([String], nextPage: Int?)
        case setLoadingNextPage(Bool)
    }
    
    /*
     State
     - query : URL에 사용될 query
     - repos : tableView에 쓰일 배열 변수
     - nextPage : 다음 페이지 번호를 저장할 변수
     - isLoadingNextPage : 다음 페이지 로딩 중인지 아닌지를 저장할 변수
     - initialState : 처음 상태를 저장
     */
    struct State {
        var query: String?
        /// 검색 결과
        var repos: [String] = []
        /// 다음 페이지
        var nextPage: Int?
        /// 로딩중
        var isLoadingNextPage: Bool = false
    }
    
    /// 처음 상태를 저장
    let initialState = State()
    
    /*
     updateQuery
     - updateQuery가 action으로 들어오면 -> Mutation의 setQuery + search 메소드를 concat -> return
     
     loadNextPage
     - 처음에 isLoadingNextPage가 true 상태라면, 액션을 받지 않음
     - page는 currentPage의 nextPage를 받을 변수
     - setLoadingNextPage를 true로 하고, search를 통해 appendRepos로 데이터 불러오고, setLoadingNextPage를 false로 해서 return
     */
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateQuery(let query):
            return Observable.concat([
                Observable.just(Mutation.setQuery(query)),
                
                self.search(query: query, page: 1)
                    .take(until: self.action.filter(Action.isUpdateQueryAction))
                    .map { Mutation.appendRepos($0, nextPage: $1) },
                
                Observable.just(Mutation.setLoadingNextPage(false))
            ])
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            
            return Observable.concat([
                Observable.just(.setLoadingNextPage(true)),
                
                self.search(query: currentState.query, page: page)
                    .take(until: self.action.filter(Action.isUpdateQueryAction))
                    .map { Mutation.appendRepos($0, nextPage: $1) },
                
                Observable.just(.setLoadingNextPage(false))
            ])
        }
    }
    
    // action에서 받은 mutation을 통해 reduce 메소드에서 State를 업데이트
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setQuery(let query):
            var newState = state
            newState.query = query
            return newState
        case .setRepos(let array, let nextPage):
            var newState = state
            newState.repos = array
            newState.nextPage = nextPage
            return newState
        case .appendRepos(let array, let nextPage):
            var newState = state
            newState.repos = array
            newState.nextPage = nextPage
            return newState
        case .setLoadingNextPage(let isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        }
    }
    
}

// MARK: - Network

extension GithubSearchReactor {
    
    private func url(for query: String?, page: Int) -> URL? {
        guard let query = query, !query.isEmpty else { return nil }
        return URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
    }
    
    private func search(query: String?, page: Int) -> Observable<(repos: [String], nextPage: Int?)> {
        let emptyResult: ([String], Int?) = ([], nil)
        guard let url = self.url(for: query, page: page) else { return .just(emptyResult) }
        
        var repos : [String] = []
        var nextPage : Int?
        
        AF.request(url, method: .get)
            .responseDecodable(of: [String].self) { response in
                guard case .success(let data) = response.result else { return }
                repos = data
                nextPage = data.isEmpty ? nil : page + 1
            }
            .resume()
        
        return .just((repos, nextPage))
    }
    
}

// MARK: - Action

extension GithubSearchReactor.Action {
    
    static func isUpdateQueryAction(_ action: GithubSearchReactor.Action) -> Bool {
        if case .updateQuery = action {
            return true
        } else {
            return false
        }
    }
    
}
