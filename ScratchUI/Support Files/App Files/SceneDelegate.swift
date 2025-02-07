//
//  SceneDelegate.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/08/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: (any CoordinatorProtocol)?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        appCoordinator = makeMenuCoordinator()
        guard let menuScreen = appCoordinator?.screen as? UIViewController else {return }

        let navigationVC = InitialViewController()
        configWindow(scene, setRoot: navigationVC)
        navigationVC.setViewControllers([menuScreen], animated: false)

    }
}


extension SceneDelegate {
    //make primary associated type for coordinator protocol, it being the type of the screen
    func makeMenuCoordinator() -> some CoordinatorProtocol {

        let menuManifest: Manifest<MenuViewInterface, MenuPresenterInterface, MenuInteractorInterface, MenuDataManagerProtocol>
        menuManifest = .init(wirings: {
            let router: Router<MenuFlows> = Router { flow in
                switch flow {
                    case .contacts: print(flow)
                    default: print(flow)
                }
            }

            let dm = MenuDataManager()
            let interactor = MenuInteractor()
            let presenter = MenuPresenter()
            let vc = MenuTableViewController(presenter: presenter)

            interactor.dm = dm
            presenter.view = vc
            presenter.interactor = interactor
            presenter.router = router
            return (vc, (presenter, interactor, dm))
        })

        return Coordinator(scene: menuManifest)
    }

    func configWindow(_ scene: UIScene, setRoot root: UIViewController) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        window?.backgroundColor = .cyan
        window?.rootViewController = root
    }

    func makeAppCoordinator() {
        let appManifest: Manifest = .init { (InitialViewController(), ()) }
        appCoordinator = Coordinator(scene: appManifest)
    }

    func makeConcreteMenuCoordinator(with navigator: UINavigationController) -> some CoordinatorProtocol {
        let coordinator = MenuCoordinator(navigator: navigator)
        coordinator.wire()
        coordinator.start()
        return coordinator
    }
}
