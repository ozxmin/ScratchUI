//
//  SceneDelegate.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/08/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: CoordinatorProtocol?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let navigationVC = InitialViewController()
        configWindow(scene, withRoot: navigationVC)
        appCoordinator = concreteMenuCoordinator(withNavigator: navigationVC)

    }
}


extension SceneDelegate {
    func configWindow(_ scene: UIScene, withRoot root: UIViewController) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        window?.backgroundColor = .cyan
        window?.rootViewController = root
    }

    func concreteMenuCoordinator(withNavigator navigator: UINavigationController) -> some CoordinatorProtocol {
        let coordinator = MenuCoordinator(navigator: navigator)
        coordinator.wire()
        coordinator.start()
        return coordinator
    }
}
