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


// TODO:
// Use reflection to make it easier to add new scene cases.
// Desired output: Just add a case to have everything working
// i.e.: Add a case, raw type is an a repository instance. The rawtype is the title.
// the mirror fills in the repo computed variable

@dynamicMemberLookup
enum Scene: String, CaseIterable {
    case contacts = "Contacts"
    case details = "Details"
    case collection = "Collection"

    var repo: Repository {
        switch self {
            case .contacts: return make(ContactsTableViewController.self)
            case .details: return make(ContactDetailViewController.self)
            case .collection: return make(ContactsCollectionViewController.self)
        }
        
        func make(_ view: UIViewController.Type) -> Repository {
            Repository(self.rawValue, view)
        }
    }

    func create() -> UIViewController {
        guard case let .this(viewType) = repo.view else {
            return UIViewController()
        }
        let view = viewType.init()
        view.title = repo.title
        return view
    }

    func create(scene: Scene) -> UIViewController {
        scene.create()
    }

    func create(at index: Int) -> UIViewController? {
        Scene[index]?.create()
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

/// - Helpers

    subscript<T>(dynamicMember member: KeyPath<Repository, T>) -> T {
        repo[keyPath: member]
    }

    static subscript(index: Int) -> Scene? {
        guard index >= 0 && index < allCases.count else {
            return nil
        }
        return allCases[index]
    }

    var index: Int? {
        Self.allCases.firstIndex(of: self)
    }

}
