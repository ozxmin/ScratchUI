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

class Coordinator<V, each T>: CoordinatorProtocol {

    var parentCoordinator: CoordinatorProtocol?
    var childCoordinators: [CoordinatorProtocol] = []

    let manifest: Manifest<V, repeat each T>
    lazy var screen: V = { manifest.wireElements() }()

    init(scene: Manifest<V, repeat each T>) {
        self.manifest = scene
    }

    func wire() { }
    func start() { }
}



class Manifest<V, each T> {
    let elements: () -> (V, (repeat each T))

    init(wirings elements: @escaping () -> (V, (repeat each T))) {
        self.elements = elements
    }

    func wireElements() -> V {
        elements().0
    }
}
