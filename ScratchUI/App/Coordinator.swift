//
//  Coordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 06/02/25.
//

import Foundation
import UIKit //fix

protocol ManifestProtocol {
    associatedtype Artifact
    associatedtype Dependencies
    typealias Module = (Self.Artifact, Self.Dependencies)
    var wirings: Module { get }
    init()
}

protocol SceneContainer: AnyObject {
    func request<T>(navigateTo scene: Coordinator<T>)
    var parent: SceneContainer? { get set }
    var children: [SceneContainer]? { get set }
}

final class Coordinator<Scene: ManifestProtocol>: SceneContainer {
    var parent: SceneContainer?
    var children: [SceneContainer]?
    let scene: Scene
    lazy var screen: Scene.Artifact = { scene.wirings.0 }()

    init() { scene = Scene() }
    init(module: Scene) { self.scene = module }

    func start() {
        parent?.request(navigateTo: self)
    }

    func didFinish(child: Coordinator) {
        guard let children, let childIndex = children
            .firstIndex(where: { $0 === child }) else {
            return
        }
        self.children?.remove(at: childIndex)
    }

    func request<T>(navigateTo scene: Coordinator<T>) {
        if parent == nil {
            handleNavigation(navigator: screen, childScreen: scene)
        }
        parent?.request(navigateTo: self)
    }
}

extension Coordinator {
    func handleNavigation<T>(navigator: Scene.Artifact, childScreen: Coordinator<T>) {
        guard let navigatorVC = screen as? UINavigationController,
              let childScreen = childScreen.screen as? UIViewController else {
            preconditionFailure("casting should be possible")
        }

        navigatorVC.setViewControllers([childScreen], animated: false)
    }
}

extension Coordinator where Scene.Artifact == RootNavigationController {
    func start() {
        guard parent == nil else { return }
        let child: Coordinator<MenuList> = .init()
        child.parent = self
        children?.append(child)
        child.start()
    }
}

final class MenuList: ManifestProtocol {
    typealias Artifact = MenuViewInterface
    typealias Dependencies = (MenuPresenterInterface, MenuInteractorInterface, MenuDataManagerProtocol)

    var wirings: Module {
        let dm = MenuDataManager()
        let interactor = MenuInteractor()
        let presenter = MenuPresenter()
        let vc = MenuTableViewController(presenter: presenter)
        interactor.dm = dm
        presenter.view = vc
        presenter.interactor = interactor
        return (vc, (presenter, interactor, dm))
    }
}

final class ContactsList: ManifestProtocol {
    typealias Artifact = ContactsViewProtocol
    typealias Dependencies = ContactsPresenterProtocol
    var wirings: Module {
        (ContactsTableViewController(), ContactsPresenter())
    }
    init() { } //fix
}



extension MenuFlows {
    static func routing(flow: MenuFlows) -> any ManifestProtocol.Type {
        switch flow {
            case .contacts:
                return ContactsList.self
            default: return MenuList.self
        }
    }
}
