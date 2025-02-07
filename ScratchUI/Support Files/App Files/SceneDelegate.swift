//
//  SceneDelegate.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/08/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var root: UINavigationController?
    var appCoordinator: CoordinatorProtocol?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        configWindow(scene)
        concreteMenuCoordinator()
    }
}


extension SceneDelegate {

    func configWindow(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        window?.backgroundColor = .cyan
    }

    func concreteMenuCoordinator() {
        let navigationVC = InitialViewController()
        window?.rootViewController = navigationVC

        let coordinator = MenuCoordinator(navigator: navigationVC)
        coordinator.wire()
        coordinator.start()
        self.appCoordinator = coordinator
    }
}
