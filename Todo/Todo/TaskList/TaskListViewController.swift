//
//  TaskListViewController.swift
//  Todo
//
//  Created by 김소연 on 11/10/23.
//

import UIKit

import RealityKit
import RxCocoa
import RxSwift
import SnapKit

final class TaskListViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var tableView = UITableView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    
    
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
