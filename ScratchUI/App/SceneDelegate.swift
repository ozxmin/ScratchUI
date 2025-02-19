//
//  SceneDelegate.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/08/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: SceneCoordinator<RootNavigationController>?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let rootView = RootNavigationController()
        configWindow(scene, setRoot: rootView)

        appCoordinator = SceneCoordinator(module: rootView)
        appCoordinator?.start()



//        appCoordinator = makeMenuCoordinator()
//        guard let menuScreen = appCoordinator?.screen as? UIViewController else {
//            return
//        }
//
//        let navigationVC = RootNavigationController()
//        configWindow(scene, setRoot: navigationVC)
//        navigationVC.setViewControllers([menuScreen], animated: false)
    }
}

extension RootNavigationController: ModuleProtocol {
    typealias Screen = RootNavigationController
    typealias Dependencies = Void
    var wiring: Module {
        (self, ())
    }
}



extension SceneDelegate {
    //make primary associated type for coordinator protocol, it being the type of the screen
    func makeMenuCoordinator() -> some CoordinatorProtocol {

        let manifest = Manifest<MenuViewInterface, MenuPresenterInterface, MenuInteractorInterface, MenuDataManagerProtocol>.self

        let menuManifest = manifest.init {
            let dm = MenuDataManager()
            let interactor = MenuInteractor()
            let presenter = MenuPresenter()
            let vc = MenuTableViewController(presenter: presenter)
            interactor.dm = dm
            presenter.view = vc
            presenter.interactor = interactor
            return (vc, (presenter, interactor, dm))
        }
        return Coordinator(scene: menuManifest)
    }

    
    func configWindow(_ scene: UIScene, setRoot root: UIViewController) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.frame = windowScene.coordinateSpace.bounds
        window?.makeKeyAndVisible()
        window?.backgroundColor = .cyan
        window?.rootViewController = root
    }

    func makeConcreteMenuCoordinator(with navigator: UINavigationController) -> some UIKitCoordinator {
        let coordinator = MenuCoordinator(navigator: navigator)
        coordinator.wire()
        coordinator.start()
        return coordinator
    }
}
