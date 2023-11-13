//
//  RepoSearchViewController.swift
//  GithubSearch
//
//  Created by 김소연 on 11/13/23.
//

import UIKit

import RIBs
import RxSwift
import SnapKit

final class RepoSearchViewController:
    UIViewController,
    RepoSearchPresentable,
    RepoSearchViewControllable
{

    // MARK: - Views
    
    private lazy var tableView = UITableView()
    private lazy var searchTextField = UITextField()
    
    // MARK: - Properties
    
    weak var listener: RepoSearchPresentableListener?
    private var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(listener: listener)
    }
    
    private func bind(listener: RepoSearchPresentableListener?) {
        guard let listener = listener else { return }
        bindActions()
        bindStates(listener: listener)
    }
}

// MARK: - Binding Actions

extension RepoSearchViewController {
    
    private func bindActions() {
        bindTextFieldAction()
    }
    
    private func bindTextFieldAction() {
        searchTextField
            .rx
            .controlEvent(.editingChanged)
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.listener?.updateQuery(query: owner.searchTextField.text)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Binding State

extension RepoSearchViewController {
    
    private func bindStates(listener: RepoSearchPresentableListener) {
        listener.state.map { $0.repos }
            .bind(to: tableView.rx.items(cellIdentifier: "GithubSearchCell", cellType: GithubSearchCell.self)) { indexPath, repo, cell in
                cell.fetchData(data: repo)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - ConfigureUI

extension RepoSearchViewController {
    
    private func configureUI() {
        view.backgroundColor = .white
        
        layout()
        
        configureTableView()
    }
    
    private func layout() {
        searchTextField.placeholder = "Enter Repo Name"
        searchTextField.borderStyle = .roundedRect
        
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        
        searchTextField.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        tableView.register(GithubSearchCell.self, forCellReuseIdentifier: "GithubSearchCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.verticalScrollIndicatorInsets.top = tableView.contentInset.top
    }
    
}

