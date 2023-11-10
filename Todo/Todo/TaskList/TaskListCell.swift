//
//  TaskListCell.swift
//  Todo
//
//  Created by 김소연 on 11/10/23.
//

import UIKit

import SnapKit

final class TaskListCell: UITableViewCell {
    
    // MARK: - Views
    
    private lazy var titleLabel = UILabel()
    
    // MARK: - Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigureUI
    
    func configureCell(with item: Task) {
        titleLabel.text = item.title
    }
    
}

extension TaskListCell {
    
    private func configureUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .current)
        titleLabel.textColor = .systemTeal
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
        }
    }
    
}
