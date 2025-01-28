//
//  MenuCoordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 06/01/25.
//

import UIKit

protocol CoordinatorTP {
    func wire()
    func transition()
}

protocol CoordinatorProtocol: AnyObject {
    var parentCoordinator: CoordinatorProtocol? { get set }
    var navigator: UINavigationController? { get set }
    func start()
}

class MenuCoordinator: CoordinatorProtocol  {
    var parentCoordinator: CoordinatorProtocol?
    var childCoordinators: [CoordinatorProtocol] = []
    var navigator: UINavigationController?
    var scene: UIViewController?

    init(navigationController: UINavigationController) {
        self.navigator = navigationController
        scene = wire()
    }

    //show 
    func start() {
        navigator?.setViewControllers([scene!], animated: false)
    }

    func wire() -> UIViewController {
        let dm = MenuDataManager()
        let interactor = MenuInteractor()
        let presenter = MenuPresenter()
        let vc = MenuTableViewController(presenter: presenter)

        let router: Router<MenuFlows> = Router { flow in
            switch flow {
                case .contacts:
                    self.prepare(scene: ContactsCoordinator.self)

                default: print(flow)
            }
        }

        presenter.router = router
        presenter.view = vc
        presenter.interactor = interactor

        interactor.dm = dm

        let router2 = MenuRouter()
        router2.transitionCompletion = { [weak self] (sceneCoordinator: CoordinatorProtocol) in
            sceneCoordinator.parentCoordinator = self
            self?.childCoordinators.append(sceneCoordinator)
            sceneCoordinator.navigator = self?.navigator
            sceneCoordinator.start()
        }

        return vc
    }

    func transition(to view: UIViewController) {
        navigator?.show(view, sender: nil)
    }

    func prepare<T: CoordinatorProtocol>(scene: T.Type) {
        

    }
}

protocol RouterInterface<Flows> {
    associatedtype Flows
    var flowTo: ((Flows) -> Void)? { get }
}

struct Router<T>: RouterInterface {
    let flowTo: ((T) -> Void)?
    init(flowTo: @escaping (T) -> Void) {
        self.flowTo = flowTo
    }
}


class MenuRouter {
    var flowTo: ((MenuFlows) -> Void)?
    var transitionCompletion: ((CoordinatorProtocol) -> Void)?
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
        let contactsCoordinator = ContactsCoordinator()
        transitionCompletion?(contactsCoordinator)
    }
}

enum Flows<T> {
    case profilePicture
    indirect case settings(T)
    indirect case home(Flows)

    func navigate(to: Self) {

    }
}
