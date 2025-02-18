//
//  MenuCoordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 06/01/25.
//

import UIKit


protocol UIKitCoordinator: AnyObject {
    typealias AnyCoordinator = UIKitCoordinator
    var navigator: UINavigationController? { get set }
    var parentCoordinator: AnyCoordinator? { get set }
    func start()
}

class MenuCoordinator: UIKitCoordinator {
    var navigator: UINavigationController?
    var parentCoordinator: AnyCoordinator?
    var childCoordinators: [AnyCoordinator] = []

    var screen: UIViewController?

    init(navigator: UINavigationController) {
        self.navigator = navigator
    }

    //show 
    func start() {
        navigator?.setViewControllers([screen!], animated: false)
    }

    func wire() {
        let dm = MenuDataManager()
        let interactor = MenuInteractor()
        let presenter = MenuPresenter()
        let vc = MenuTableViewController(presenter: presenter)

        presenter.view = vc
        presenter.interactor = interactor
        interactor.dm = dm

        let router2 = MenuRouter()
        router2.transitionCompletion = { [weak self] (sceneCoordinator: UIKitCoordinator) in
            sceneCoordinator.parentCoordinator = self
            self?.childCoordinators.append(sceneCoordinator)
            sceneCoordinator.start()
        }

        screen = vc
    }

    func transition(to view: UIViewController) {
        navigator?.show(view, sender: nil)
    }

    func prepare<T: UIKitCoordinator>(scene: T.Type) { }
}

protocol RouterInterface<Flow> {
    associatedtype Flow
    var flowTo: ((Flow) -> Void)? { get }
}

struct Router<T>: RouterInterface {
    let flowTo: ((T) -> Void)?
    init(flowTo: @escaping (T) -> Void) {
        self.flowTo = flowTo
    }
}


class MenuRouter {
    var flowTo: ((MenuFlows) -> Void)?
    var transitionCompletion: ((UIKitCoordinator) -> Void)?
    func navigate(to flow: MenuFlows) {
        switch flow {
            case .collection: print("collections")
            case .contacts:
                contactsScene()
            case .details: print("details")
            default: print("default")
        }
    }

    private func contactsScene() {
//        let contactsCoordinator = ContactsCoordinator()
//        transitionCompletion?(contactsCoordinator)
    }
}

enum Flows<T> {
    case profilePicture
    indirect case settings(T)
    indirect case home(Flows)

    func navigate(to flow: Self) { }
}
