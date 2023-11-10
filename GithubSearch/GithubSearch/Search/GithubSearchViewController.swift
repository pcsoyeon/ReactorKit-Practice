//
//  ListViewController.swift
//  GithubSearch
//
//  Created by 김소연 on 11/10/23.
//

import UIKit
import SafariServices

import RxSwift
import ReactorKit
import RxCocoa
import SnapKit

final class GithubSearchViewController:
    UIViewController,
    View
{
    typealias Reactor = GithubSearchReactor
    
    // MARK: - Views
    
    private lazy var tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.setAnimationsEnabled(false)
        searchController.isActive = true
        searchController.isActive = false
        UIView.setAnimationsEnabled(true)
    }
    
    // MARK: - Bind
    
    func bind(reactor: GithubSearchReactor) {
        // Action
        searchController.searchBar
            .rx
            .text
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .contentOffset
            .filter { [weak self] offset in
                guard let `self` = self else { return false }
                guard self.tableView.frame.height > 0 else { return false }
                return offset.y + self.tableView.frame.height >= self.tableView.contentSize.height - 100
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .itemSelected
            .bind(with: self) { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: false)
                guard let url = URL(string: "https://github.com/\(reactor.currentState.repos[indexPath.row])") else { return }
                let viewController = SFSafariViewController(url: url)
                self.searchController.present(viewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.repos }
            .bind(to: tableView.rx.items(cellIdentifier: "GithubSearchCell", cellType: GithubSearchCell.self)) { indexPath, repo, cell in
                cell.fetchData(data: repo)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - ConfigureUI

extension GithubSearchViewController {
    
    private func configureUI() {
        view.backgroundColor = .white
        
        layout()
        
        configureTableView()
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        tableView.register(GithubSearchCell.self, forCellReuseIdentifier: "GithubSearchCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.verticalScrollIndicatorInsets.top = tableView.contentInset.top
        
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
}

