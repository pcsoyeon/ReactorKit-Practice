//
//  GithubSearchCell.swift
//  GithubSearch
//
//  Created by 김소연 on 11/10/23.
//

import UIKit

import SnapKit

import UIKit
import SnapKit

final class GithubSearchCell: UITableViewCell {
    
    // MARK: - Views
    
    private lazy var titleLabel = UILabel()
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func fetchData(data: String) {
        titleLabel.text = data
    }
}

// MARK: - ConfigureUI

extension GithubSearchCell {
    
    private func configureUI() {
        contentView.backgroundColor = .white
        
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .regular)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
}
