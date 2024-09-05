//
//  DemoCoordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/09/24.
//

import UIKit

@dynamicMemberLookup
enum Scene: String, CaseIterable {
    case contacts = "Contacts"
    case details = "Details"

    var repo: Repository {
        switch self {
            case .contacts: return make(ContactsTableViewController.self)
            case .details: return make(ContactDetailViewController.self)
        }
        
        func make(_ view: UIViewController.Type) -> Repository {
            Repository(self.rawValue, view)
        }
    }

    func create() -> UIViewController {
        let view = repo.view.init()
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
        let view: UIViewController.Type
        let dependencies: Any?

        init(_ title: String, _ view: UIViewController.Type) {
            self.title = title
            self.view = view
            self.dependencies = nil
        }
    }

/// - Helpers
    static subscript(index: Int) -> Scene? {
        guard index >= 0 && index < allCases.count else {
            return nil
        }
        return allCases[index]
    }

    var index: Int? {
        Self.allCases.firstIndex(of: self)
    }

    subscript<T>(dynamicMember member: KeyPath<Repository, T>) -> T {
        repo[keyPath: member]
    }



}
