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

final class ListViewController: UIViewController {
    
    // MARK: - Views
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
}

// MARK: - ConfigureUI

extension ListViewController {
    
    private func configureUI() {
        view.backgroundColor = .white
        
        layout()
    }
    
    private func layout() {
        
    }
    
}
