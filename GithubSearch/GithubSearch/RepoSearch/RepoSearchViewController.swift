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

protocol RepoSearchPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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

