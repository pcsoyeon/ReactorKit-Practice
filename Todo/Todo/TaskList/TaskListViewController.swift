//
//  TaskListViewController.swift
//  Todo
//
//  Created by 김소연 on 11/10/23.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class TaskListViewController: UIViewController, View {
    
    typealias Reactor = TaskListReactor
    
    // MARK: - Views
    
    private lazy var tableView = UITableView()
    
    // MARK: - Properties
    
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func bind(reactor: TaskListReactor) {
        
    }
    
}

// MARK: - ConfigureUI

extension TaskListViewController {
    
    private func configureUI() {
        tableView.register(TaskListCell.self, forCellReuseIdentifier: "TaskListCell")
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
