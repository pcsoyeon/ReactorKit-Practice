//
//  RepoSearchRepository.swift
//  GithubSearch
//
//  Created by 김소연 on 11/13/23.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

protocol RepoSearchRepository {
    func search(query: String?, page: Int) -> Observable<(repos: [String], nextPage: Int?)>
}

final class RepoSearchImpl: RepoSearchRepository {
    
    private func url(for query: String?, page: Int) -> URL? {
        guard let query = query, !query.isEmpty else { return nil }
        return URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
    }
    
    func search(query: String?, page: Int) -> Observable<(repos: [String], nextPage: Int?)> {
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
    
}
