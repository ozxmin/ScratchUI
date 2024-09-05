//
//  SceneDelegate.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/08/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        window?.backgroundColor = .cyan
        
        // let initialViewController = UINavigationController(rootViewController: MenuTableViewController())
        let initialViewController = InitialViewController(rootViewController: MenuTableViewController())
        window?.rootViewController = initialViewController
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
