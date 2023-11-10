//
//  PhotoViewController.swift
//  Photo
//
//  Created by 김소연 on 11/10/23.
//

import UIKit

import RIBs
import RxSwift
import SnapKit

protocol PhotoPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class PhotoViewController: UIViewController, PhotoPresentable, PhotoViewControllable {
    
    // MARK: - Views
    
    private lazy var photoImageView = UIImageView()
    private lazy var loadButton = UIButton()

    // MARK: - Properties
    
    weak var listener: PhotoPresentableListener?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
}

// MARK: - ConfigureUI

extension PhotoViewController {
    
    private func configureUI() {
        view.backgroundColor = .white
        photoImageView.backgroundColor = .systemGray6
        
        loadButton.setTitle("Load Image", for: .normal)
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.backgroundColor = .systemBlue
        
        view.addSubview(photoImageView)
        view.addSubview(loadButton)
        
        photoImageView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.center.equalToSuperview()
        }
        loadButton.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
    
}
