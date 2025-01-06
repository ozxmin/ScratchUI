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
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navigationVC = InitialViewController()
        let coordinator = MenuCoordinator(navigationController: navigationVC)

        coordinator.start()
        self.appCoordinator = coordinator

        window = UIWindow(windowScene: windowScene)
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        window?.backgroundColor = .cyan

//        let menuScene = Factory2.make(scene: .initial)
//        let initialVC = InitialViewController(rootViewController: menuScene!)
        window?.rootViewController = navigationVC
    }
}
