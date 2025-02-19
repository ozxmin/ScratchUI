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
    var completion: ((MenuFlows) -> ())? { get set }
    init()
}

protocol SceneContainer: AnyObject {
    func request<T>(navigateTo scene: Coordinator<T>)
    var parent: SceneContainer? { get set }
    var children: [SceneContainer] { get set }
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
        self.scene.completion = navFlow(_:)
    }

    func navFlow(_ flow: MenuFlows) {
        let flow = MenuFlows.routing(flow: flow)
        flow.parent = self
        children.append(flow)

        flow.start()

        print("self")
        print(self)
        print("flow:")
        print(flow)
        print("self.children:")
        print(children)
        print("child.parent:")
        print(flow.parent)

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

    func request<T>(navigateTo child: Coordinator<T>) {
        if parent == nil {
            if children.isEmpty {
                handleNavigation(navigator: screen, childScreen: child)
            } else {
                push(navigator: screen, childScreen: child)
            }
        }
        parent?.request(navigateTo: child)
    }
}

extension Coordinator {

    func push<T>(navigator: Scene.Artifact, childScreen: Coordinator<T>) {
        guard let navigatorVC = screen as? UINavigationController,
              let childScreen = childScreen.screen as? UIViewController else {
            preconditionFailure("casting should be possible")
        }
        navigatorVC.show(childScreen, sender: nil)
    }

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
        let child = MenuFlows.routing(flow: .initial)
        child.parent = self
        children.append(child)
        child.start()
    }
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

extension MenuFlows {
    static func routing(flow: MenuFlows) -> any SceneContainer {
        switch flow {
            case .contacts:
                return Coordinator<MenuList>()
            case .initial:
                return Coordinator<MenuList>()
            default: return Coordinator<ContactsList>()
        }
    }
}
