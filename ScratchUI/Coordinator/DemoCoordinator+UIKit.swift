//
//  DemoCoordinator+UIKit.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 20/12/24.
//

import UIKit

extension Coordinator {
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

    func create(scene: Coordinator) -> UIViewController {
        scene.create()
    }

    func create(at index: Int) -> UIViewController? {
        Coordinator[index]?.create()
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
