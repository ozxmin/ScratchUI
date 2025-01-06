//
//  DemoCoordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/09/24.
//

import UIKit

enum Either<T, U> {
    case this(T)
    case that(U)
}

// TODO: - Use reflection to make it easier to add new scene cases.
// -
// Desired output: Just add a case to have everything working
// i.e.: Add a case, raw type is an a repository instance. The raw-type is the title.
// the mirror fills in the repo computed variable

//Router
//Coordinator
//Repository
//Compose
//Flows
//Navigator
//locator

//protocol Router<Flow>

protocol RouterProtocol {
    associatedtype Flows
    func navigate(to flow: Flows)
}

class MenuRouter: RouterProtocol {
    var transitionCompletion: ((CoordinatorProtocol) -> Void)?
    enum Flow {
        case details
        case contacts
        case collections
    }
    func navigate(to flow: Flow) {
        switch flow {
            case .collections: print("collections")
            case .contacts:
                navigateToContacts()
            case .details: print("details")
        }
    }

    private func navigateToContacts() {
        let coordinator = ContactsCoordinator()
        coordinator.start()
        transitionCompletion?(coordinator)
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



@dynamicMemberLookup
enum Coordinator: String, CaseIterable {
    case initial = "Initial"
    case contacts = "Contacts"
    case details = "Details"
    case collection = "Collection"
}

/// - Helpers
extension Coordinator {
    subscript<T>(dynamicMember member: KeyPath<Repository, T>) -> T {
        repo[keyPath: member]
    }

    static subscript(index: Int) -> Coordinator? {
        guard index >= 0 && index < allCases.count else {
            return nil
        }
        return allCases[index]
    }

    var index: Int? {
        Self.allCases.firstIndex(of: self)
    }
}


enum Repository: String {
    case initial = "Initial"
    case contacts = "Contacts"
    case details = "Details"
    case collection = "Collection"
}

enum Scene: CaseIterable {
    case initial
    case contacts
    case details
    case collection
}

struct Factory2 {
    static func make(scene: Repository) -> UIViewController? {
        switch scene {
            case .initial:
                let dm = MenuDataManager()
                let interactor = MenuInteractor()
                let presenter = MenuPresenter()
                let viewController = MenuTableViewController(presenter: presenter)

                interactor.dm = dm
                presenter.interactor = interactor
                return viewController
            case .contacts:
                return nil
            case .details:
                return nil
            case .collection:
                return nil
        }
    }
}
