//
//  ContactsCoordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 05/01/25.
//

import Foundation
import UIKit

final class ContactsCoordinator: UIKitCoordinator {
    var screen = ContactsTableViewController()

    func wire() {
        
    }
    
    var childCoordinators: [AnyCoordinator] = []
    weak var parentCoordinator: AnyCoordinator?
    weak var navigator: UINavigationController?

    func start() {
        let interactor = ContactsInteractor()
        let router = ContactsRouter()
        let presenter = ContactsPresenter()
        let vc = screen

        vc.presenter = presenter

        presenter.view = vc
        presenter.interactor = interactor
        presenter.router = router
        navigator?.show(vc, sender: nil)
    }
}

class ContactsRouter {

}
