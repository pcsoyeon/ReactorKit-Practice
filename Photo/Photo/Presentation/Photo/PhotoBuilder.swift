//
//  PhotoBuilder.swift
//  Photo
//
//  Created by 김소연 on 11/10/23.
//

import RIBs

protocol PhotoDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PhotoComponent: Component<PhotoDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PhotoBuildable: Buildable {
    func build(withListener listener: PhotoListener) -> PhotoRouting
}

final class PhotoBuilder: Builder<PhotoDependency>, PhotoBuildable {

    override init(dependency: PhotoDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PhotoListener) -> PhotoRouting {
        let component = PhotoComponent(dependency: dependency)
        let viewController = PhotoViewController()
        let interactor = PhotoInteractor(presenter: viewController)
        interactor.listener = listener
        return PhotoRouter(interactor: interactor, viewController: viewController)
    }
}
