//
//  MenuCoordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 06/01/25.
//

import Foundation

final class MenuManifest: ManifestProtocol {
    typealias Artifact = MenuViewInterface
    typealias Dependencies = (MenuPresenterInterface, MenuInteractorInterface, MenuDataManagerProtocol)

    var completion: ((any SceneContainer) -> Void)?

    var wirings: Module {
        let dm = MenuDataManager()
        let interactor = MenuInteractor()
        let presenter = MenuPresenter()
        let vc = MenuTableViewController(presenter: presenter)
        interactor.dm = dm
        presenter.view = vc
        presenter.interactor = interactor
        presenter.route = { [weak self] flow in
            self?.completion?(flow.toScene)
        }
        return (vc, (presenter, interactor, dm))
    }
}

extension MenuFlows {
    var toScene: any SceneContainer {
        switch self {
            case .contacts:
                return Coordinator<ContactsManifest>()
            case .initial:
                return Coordinator<MenuManifest>()
            default: return Coordinator<ContactsManifest>()
        }

    }
}

