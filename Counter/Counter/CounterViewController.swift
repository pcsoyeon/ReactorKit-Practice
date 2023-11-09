//
//  CounterViewController.swift
//  Counter
//
//  Created by 김소연 on 11/9/23.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class CounterViewController: UIViewController, View {
    
    typealias Reactor = CounterReactor
    
    // MARK: - Views
    
    private lazy var decreaseButton = UIButton()
    private lazy var increaseButton = UIButton()
    private lazy var valueLabel = UILabel()
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helper
    
    private func configureUI() {
        view.backgroundColor = .white
        
        decreaseButton.setTitle("-", for: .normal)
        decreaseButton.setTitleColor(.systemBlue, for: .normal)
        decreaseButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .medium)
        
        increaseButton.setTitle("+", for: .normal)
        increaseButton.setTitleColor(.systemBlue, for: .normal)
        increaseButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .medium)
        
        valueLabel.text = "0"
        valueLabel.textColor = .black
        valueLabel.font = .systemFont(ofSize: 28, weight: .medium)
        
        layout()
    }
    
    private func layout() {
        view.addSubview(decreaseButton)
        view.addSubview(valueLabel)
        view.addSubview(increaseButton)
        
        decreaseButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(valueLabel.snp.left).offset(-10)
        }
        valueLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        increaseButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(valueLabel.snp.right).offset(10)
        }
    }
    
}

// MARK: - Reactor Bind

extension CounterViewController {
    
    func bind(reactor: CounterReactor) {
        
    }
    
}
