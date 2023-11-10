//
//  PhotoViewController.swift
//  Photo
//
//  Created by 김소연 on 11/10/23.
//

import RIBs
import RxSwift
import UIKit

protocol PhotoPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class PhotoViewController: UIViewController, PhotoPresentable, PhotoViewControllable {

    weak var listener: PhotoPresentableListener?
}
