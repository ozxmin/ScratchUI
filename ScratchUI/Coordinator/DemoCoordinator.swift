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

enum Scene {
    case initial
    case contacts
    case details
    case collection
}

struct Coordinator2 {
    static func make(scene: Repository) -> UIViewController? {
        switch scene {
            case .initial:
                let dm = MenuDataManager()
                let interactor = MenuInteractor()
                interactor.dm = dm

                let presenter = MenuPresenter()
                presenter.interactor = interactor

                let viewController = MenuTableViewController(presenter: presenter)

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
