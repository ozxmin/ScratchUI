//
//  ContactsCoordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 05/01/25.
//

import Foundation

final class ContactsManifest: ManifestProtocol {
    var completion: ((any SceneContainer) -> Void)?

    typealias Artifact = ContactsViewProtocol
    typealias Dependencies = (ContactsPresenterProtocol, ContactsInteractor)

    var wirings: Module {
        let presenter = ContactsPresenter()
        let interactor = ContactsInteractor()
        let vc = ContactsTableViewController()

        presenter.interactor = interactor
        presenter.view = vc
        vc.presenter = presenter
        return (vc, (presenter, interactor))
    }
}
