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

        let router2: GenericFlow<MenuFlows> = .init()
        router2.navigates = { flow in
            print("navigates")
            switch flow {
                case .collection:
                    print(flow)
                case .contacts:
                    print(flow)
                default: print(flow)
            }
        }

        let router = MenuRouter()

        router.transitionCompletion = { [weak self] sceneCoordinator in
            sceneCoordinator.parentCoordinator = self
            self?.childCoordinators.append(sceneCoordinator)
            sceneCoordinator.navigator = self?.navigator
            sceneCoordinator.start()
        }

        let presenter = MenuPresenter()
        let vc = MenuTableViewController(presenter: presenter)

        presenter.router = router2
        presenter.view = vc
        presenter.interactor = interactor

        interactor.dm = dm
        return vc
    }

    func transition(to view: UIViewController) {
        navigator?.show(view, sender: nil)
    }
}


protocol RouterProtocol {
    associatedtype Flows
    func navigate(to flow: Flows)
    var navigates: ((Flows) -> Void)? { get set }
}

class MenuRouter: RouterProtocol {
    var navigates: ((MenuFlows) -> Void)?
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

/**

Scene:
 - coordinator
 - flows declaration
 - repository locator
 - data passing
 - wiring
 - scene navigation
 - navigation
*/

class GenericFlow<T> {
    var navigates: ((T) -> Void)?
}
extension GenericFlow: RouterProtocol where T == MenuFlows {

    func navigate(to flow: MenuFlows) {

        switch flow {
            case .collection: print("collections")
            case .contacts:
                print("contacts")
            case .details: print("details")
            default: print("default")
        }
    }
}


protocol Scene { }
enum Flows<T: Scene> {
    case profilePicture
    indirect case settings(T)
    indirect case home(Flows)

    func navigate(to: Self) {

    }
}

