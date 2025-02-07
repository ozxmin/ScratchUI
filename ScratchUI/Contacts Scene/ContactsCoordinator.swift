//
//  ContactsCoordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 05/01/25.
//

import Foundation
import UIKit

final class ContactsCoordinator: CoordinatorProtocol {
    func wire() {
        
    }
    
    var childCoordinators: [CoordinatorProtocol] = []
    weak var parentCoordinator: CoordinatorProtocol?
    weak var navigator: UINavigationController?

    func start() {
        let interactor = ContactsInteractor()
        let router = ContactsRouter()
        let presenter = ContactsPresenter()
        let vc = ContactsTableViewController()

        vc.presenter = presenter

        presenter.view = vc
        presenter.interactor = interactor
        presenter.router = router
        navigator?.show(vc, sender: nil)
    }
}

class ContactsRouter {

}
