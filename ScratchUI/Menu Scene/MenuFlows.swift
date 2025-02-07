//
//  MenuFlows.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 06/02/25.
//

import UIKit


@dynamicMemberLookup
enum MenuFlows: String, CaseIterable {
    // Fix: Leaking presentation details (string)
    case initial = "Initial"
    case contacts = "Contacts"
    case details = "Details"
    case collection = "Collection"
}

/// - Helpers
extension MenuFlows {
    subscript<T>(dynamicMember member: KeyPath<Repository, T>) -> T {
        repo[keyPath: member]
    }

    static subscript(index: Int) -> MenuFlows? {
        guard index >= 0 && index < allCases.count else {
            return nil
        }
        return allCases[index]
    }

    var index: Int? {
        Self.allCases.firstIndex(of: self)
    }
}

struct Factory2 {
    static func make(scene: MenuFlows) -> UIViewController? {
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


extension MenuFlows {
    var repo: Repository {
        switch self {
            case .initial: return make(MenuTableViewController.self)
            case .contacts: return make(ContactsTableViewController.self)
            case .details: return make(ContactDetailsViewController.self)
            case .collection: return make(ContactsCollectionViewControllerTest.self)
        }

        func make(_ view: UIViewController.Type) -> Repository {
            Repository(self.rawValue, view)
        }
    }

    func create() -> UIViewController {
        guard case let .this(viewType) = repo.view else {
            return UIViewController()
        }
        let view = viewType.init(dependencies: repo.dependencies)
        view.title = repo.title
        return view
    }

    func create(scene: MenuFlows) -> UIViewController {
        scene.create()
    }

    func create(at index: Int) -> UIViewController? {
        MenuFlows[index]?.create()
    }

    struct Repository {
        let title: String
        let view: Either<UIViewController.Type, UIView.Type>
        let dependencies: Any?

        init(_ title: String, _ view: UIViewController.Type) {
            self.title = title
            self.view = .this(view)
            self.dependencies = nil
        }
    }

}

protocol Injectable {
    init<D>(dependencies: D)
}

extension Injectable where Self: UIViewController {
    init<D>(dependencies: D) {
        self.init()
    }
}
extension UIViewController: Injectable {
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





enum Either<T, U> {
    case this(T)
    case that(U)
}

