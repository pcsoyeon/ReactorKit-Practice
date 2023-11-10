//
//  ListViewController.swift
//  GithubSearch
//
//  Created by 김소연 on 11/10/23.
//

import UIKit

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
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Bind
    
    func bind(reactor: GithubSearchReactor) {
        
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
    }
    
}

