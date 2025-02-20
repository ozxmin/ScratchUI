//
//  Coordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 06/02/25.
//

import Foundation
import UIKit //fix


protocol SceneContainer: AnyObject {
    func request<T>(navigateTo scene: Coordinator<T>)
    var parent: SceneContainer? { get set }
    var children: [SceneContainer] { get }
    func start()
}

final class Coordinator<Scene: ManifestProtocol>: SceneContainer {
    var parent: SceneContainer?
    var children: [SceneContainer] = []
    var scene: Scene
    lazy var screen: Scene.Artifact = { scene.wirings.0 }()

    init() {
        scene = Scene()
        scene.completion = navFlow(_:)
    }
    init(module: Scene) {
        self.scene = module
        scene.completion = navFlow(_:)
    }

    func navFlow(_ flow: MenuFlows) {
        let coordinator = MenuFlows.routeTo(flow)
        coordinator.parent = self
        children.append(coordinator)
        coordinator.start()
    }

    func start() {
        parent?.request(navigateTo: self)
    }

    func didFinish(child: Coordinator) {
        guard let childIndex = children
            .firstIndex(where: { $0 === child }) else {
            return
        }
        self.children.remove(at: childIndex)
    }
}

//UIKit
extension Coordinator {
    func request<T>(navigateTo child: Coordinator<T>) {
        switch (parent, children.isEmpty) {
            case (.none, true): handleNavigation(navigator: screen, childScreen: child)
            case (.none, false): push(navigator: screen, childScreen: child)
            case (.some, _): parent?.request(navigateTo: child)
        }
    }

    func push<T>(navigator: Scene.Artifact, childScreen: Coordinator<T>) {
        let (navigator, vc) = cast(navigator: navigator, vc: childScreen)
        navigator.show(vc, sender: nil)
    }

    func handleNavigation<T>(navigator: Scene.Artifact, childScreen: Coordinator<T>) {
        let (navigator, vc) = cast(navigator: navigator, vc: childScreen)
        navigator.setViewControllers([vc], animated: false)
    }

    private func cast<T>(navigator: Scene.Artifact, vc: Coordinator<T>) -> (UINavigationController, UIViewController) {
        guard let navigatorVC = screen as? UINavigationController,
              let childScreen = vc.screen as? UIViewController else {
            preconditionFailure("casting should be possible")
        }
        return (navigatorVC, childScreen)
    }
}

extension Coordinator where Scene.Artifact == RootNavigationController {
    func start() {
        guard parent == nil else { return }
        let child = MenuFlows.routeTo(.initial)
        child.parent = self
        children.append(child)
        child.start()
    }
}

protocol ManifestProtocol {
    associatedtype Artifact
    associatedtype Dependencies
    typealias Module = (Self.Artifact, Self.Dependencies)
    var wirings: Module { get }
    var completion: ((MenuFlows) -> ())? { get set }
    init()
}


final class MenuList: ManifestProtocol {
    typealias Artifact = MenuViewInterface
    typealias Dependencies = (MenuPresenterInterface, MenuInteractorInterface, MenuDataManagerProtocol)

    var completion: ((MenuFlows) -> Void)?

    var wirings: Module {

        let dm = MenuDataManager()
        let interactor = MenuInteractor()
        let presenter = MenuPresenter()
        let vc = MenuTableViewController(presenter: presenter)
        interactor.dm = dm
        presenter.view = vc
        presenter.interactor = interactor
        presenter.route = completion

        return (vc, (presenter, interactor, dm))
    }
}

final class ContactsList: ManifestProtocol {
    typealias Artifact = ContactsViewProtocol
    typealias Dependencies = ContactsPresenterProtocol
    var completion: ((MenuFlows) -> Void)?
    var wirings: Module {
        (ContactsTableViewController(), ContactsPresenter())
    }
    init() { } //fix
}


protocol Route {
    associatedtype Flow where Flow == Self
    associatedtype Container = SceneContainer
    static func routeTo(_ flow: Flow) -> Container
}

extension MenuFlows: Route {
    static func routeTo(_ flow: MenuFlows) -> Container {
        switch flow {
            case .contacts:
                return Coordinator<MenuList>()
            case .initial:
                return Coordinator<MenuList>()
            default: return Coordinator<ContactsList>()
        }

    }
}
