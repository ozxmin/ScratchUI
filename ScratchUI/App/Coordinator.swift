//
//  Coordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 06/02/25.
//

import Foundation
import UIKit

protocol CoordinatorProtocol {
    associatedtype Screen where Screen == Self.Screen
    associatedtype Parent: CoordinatorProtocol

    var screen: Screen { get }
    var parentCoordinator: Parent? { get set }
    func start()
}

class Coordinator<V, each T>: CoordinatorProtocol {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator]?

    let manifest: Manifest<V, repeat each T>
    lazy var screen: V = { manifest.wireElements }()

    init(scene: Manifest<V, repeat each T>) {
        self.manifest = scene
    }

    func start() { }
}

class Manifest<V, each T> {
    typealias Components = (V, (repeat each T))
    let elements: () -> Components
    var wireElements: V { elements().0 }

    required init(wirings elements: @escaping () -> Components) {
        self.elements = elements
    }
}


protocol SceneProtocol<Screen> {
    associatedtype Screen
    associatedtype Dependencies
    typealias Scene = (Screen, Dependencies)
    var wiring: Scene { get }
}

final class SceneCoordinator<Scene: SceneProtocol> {
    var parentCoordinator: SceneCoordinator?
    var childCoordinator: [SceneCoordinator]?
    let scene: Scene
    lazy var screen: Scene.Screen = { scene.wiring.0 }()

    init(scene: Scene) {
        self.scene = scene
    }
    func navigate(to coordinator: SceneCoordinator) {

    }
}

extension SceneCoordinator where Scene.Screen: UIViewController {
    func start() {
        parentCoordinator?.navigate(to: self)
    }
}

extension SceneCoordinator where Scene.Screen == RootNavigationController {
    func start() {
    }
    func navigate<T>(to coordinator: SceneCoordinator<T>) where T.Screen: UIViewController {
        if parentCoordinator == nil {
            screen.setViewControllers([coordinator.screen], animated: false)
        }
    }
}

extension SceneCoordinator {
    func rootNavigation(root: UINavigationController) {

    }
}

extension MenuFlows {
    static func routing(flow: MenuFlows) -> any SceneProtocol.Type {
        switch flow {
            case .contacts:
                return MenuList<MenuTableViewController>.self
            default: return ContactsList.self
        }
    }
}


final class MenuList<Screen> where Screen: MenuViewInterface {
    typealias Dependencies = (MenuPresenterInterface, MenuInteractorInterface, MenuDataManagerProtocol)
}
extension MenuList: SceneProtocol where Screen == MenuTableViewController {
    var wiring:  Scene {
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

class ContactsList: SceneProtocol {
    var wiring: Scene {
        return (ContactsTableViewController(), ContactsPresenter())
    }
    typealias Screen = ContactsViewProtocol
    typealias Dependencies = ContactsPresenterProtocol
}
