//
//  CounterViewController.swift
//  Counter
//
//  Created by 김소연 on 11/10/23.
//

import UIKit

import ReactorKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit

final class CounterViewController:
    UIViewController,
    CounterPresentable,
    CounterViewControllable
{
    
    weak var listener: CounterPresentableListener?
    
    // MARK: - Views
    
    private lazy var decreaseButton = UIButton()
    private lazy var increaseButton = UIButton()
    private lazy var valueLabel = UILabel()
    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Reactor
    
    var disposeBag = DisposeBag()
    typealias Reactor = CounterReactor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(listener: listener)
    }
    
    private func bind(listener: CounterPresentableListener?) {
        guard let listener = listener else { return }
        bindActions()
        bindStates(from: listener)
    }
    
    private func bindActions() {
        increaseButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                owner.listener?.increase()
            }
            .disposed(by: disposeBag)
        
        decreaseButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                owner.listener?.decrease()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindStates(from listener: CounterPresentableListener) {
        listener.state
            .map { "\($0.value)" }
            .bind(with: self) { owner, valueString in
                owner.valueLabel.text = valueString
            }
            .disposed(by: disposeBag)
        
        listener.state
            .map { $0.alertMessage }
            .bind(with: self) { owner, alertMessage in
                print(alertMessage)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Configure UI

extension CounterViewController {
    
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
        view.addSubview(activityIndicatorView)
        
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
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(48)
        }
    }
    
}
