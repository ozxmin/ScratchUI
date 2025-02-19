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


protocol ModuleProtocol {
    associatedtype Screen
    associatedtype Dependencies
    typealias Module = (Self.Screen, Self.Dependencies)
    var wiring: Module { get }
    init()
}

protocol Coordinated: AnyObject {
    func request<T>(navigateTo scene: SceneCoordinator<T>)
    var parentCoordinator: Coordinated? { get set }
    var childCoordinators: [Coordinated]? { get set }

}

final class SceneCoordinator<Scene: ModuleProtocol>: Coordinated {
    var parentCoordinator: Coordinated?
    var childCoordinators: [Coordinated]?
    let scene: Scene
    lazy var screen: Scene.Screen = { scene.wiring.0 }()

    init(module: Scene) {
        self.scene = module
    }
    init() {
        scene = Scene()
    }

    func start() {
        parentCoordinator?.request(navigateTo: self)
    }

    func didFinish(child: SceneCoordinator) {
        guard let childCoordinators,
              let childIndex = childCoordinators
            .firstIndex(where: { $0 === child }) else {
            return
        }
        self.childCoordinators?.remove(at: childIndex)
    }
    func request<T>(navigateTo scene: SceneCoordinator<T>) {
        if parentCoordinator == nil {
            guard let navigationController = screen as? UINavigationController,
                  let screen = scene.screen as? UIViewController else {
                assert(false)
            }
            handleNavigation(navigator: navigationController, childScreen: screen)
        }
        parentCoordinator?.request(navigateTo: self)
    }
}

extension SceneCoordinator {
    func handleNavigation<N, S>(navigator: N, childScreen: S) where N: UINavigationController, S: UIViewController {
        navigator.setViewControllers([childScreen], animated: false)
    }
}


//extension SceneCoordinator where Scene.Screen: UIViewController { }

extension SceneCoordinator where Scene.Screen == RootNavigationController {
    func handleNavigation() {

    }
    func start() {
        if parentCoordinator == nil {
            let child: SceneCoordinator<MenuList> = .init()
            child.parentCoordinator = self
            childCoordinators?.append(child)
            child.start()
        }
    }

    func request<T>(navigateTo scene: SceneCoordinator<T>) where T.Screen: UIViewController {
        if parentCoordinator == nil {

        }
    }
}


final class MenuList: ModuleProtocol {
    typealias Screen = MenuViewInterface
    typealias Dependencies = (MenuPresenterInterface, MenuInteractorInterface, MenuDataManagerProtocol)

    var wiring: Module {
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

final class ContactsList: ModuleProtocol {
    var wiring: Module {
        return (ContactsTableViewController(), ContactsPresenter())
    }
    typealias Screen = ContactsViewProtocol
    typealias Dependencies = ContactsPresenterProtocol
    init() {

    }
}



extension MenuFlows {
    static func routing(flow: MenuFlows) -> any ModuleProtocol.Type {
        switch flow {
            case .contacts:
                return MenuList.self
            default: return ContactsList.self
        }
    }
}
