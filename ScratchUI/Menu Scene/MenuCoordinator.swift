//
//  MenuCoordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 06/01/25.
//

import UIKit

protocol RouterProtocol {
    associatedtype Flows
    func navigate(to flow: Flows)
}

class MenuRouter: RouterProtocol {

    var transitionCompletion: ((CoordinatorProtocol) -> Void)?
    func navigate(to flow: SceneOptions) {
        switch flow {
            case .collection: print("collections")
            case .contacts:
                navigateToContacts()
            case .details: print("details")
            default: print("default")
        }
    }

    private func navigateToContacts() {
        let coordinator = ContactsCoordinator()
        transitionCompletion?(coordinator)
        coordinator.start()

    }

}

protocol CoordinatorTP {
    func wire()
    func transition()
}

protocol CoordinatorProtocol: AnyObject {
    var parentCoordinator: CoordinatorProtocol? { get set }
    var navigator: UINavigationController? { get set }

}

class MenuCoordinator: CoordinatorProtocol  {

    var parentCoordinator: CoordinatorProtocol?
    var childCoordinators: [CoordinatorProtocol] = []
    var navigator: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigator = navigationController
    }

    func start() {
        let scene = wire()
        navigator?.setViewControllers([scene], animated: false)
    }

    func wire() -> UIViewController {
        let dm = MenuDataManager()
        let interactor = MenuInteractor()
        let menuRouter = MenuRouter()
        menuRouter.transitionCompletion = { [weak self] contactCoordinator in
            contactCoordinator.parentCoordinator = self
            self?.childCoordinators.append(contactCoordinator)
            contactCoordinator.navigator = self?.navigator
        }

        let presenter = MenuPresenter()
        let viewController = MenuTableViewController(presenter: presenter)

        presenter.router = menuRouter
        presenter.view = viewController
        presenter.interactor = interactor

        interactor.dm = dm
        return viewController
    }

    func transition(to view: UIViewController) {
        navigator?.show(view, sender: nil)
    }
}

