//
//  SceneDelegate.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/08/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    lazy var appCoordinator: Coordinator<RootModule> = .init()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        configWindow(scene, setRoot: appCoordinator.screen)
        appCoordinator.navFlow(MenuFlows.initial.toScene)
        appCoordinator.start()
    }
}

extension SceneDelegate {
    func configWindow(_ scene: UIScene, setRoot root: UIViewController) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.frame = windowScene.coordinateSpace.bounds
        window?.makeKeyAndVisible()
        window?.backgroundColor = .cyan
        window?.rootViewController = root
    }
}

// MARK: - Coordination

final class RootModule: ManifestProtocol {
    var wirings: (RootNavigationController, Void) {
        (RootNavigationController(), ())
    }
    var completion: ((any SceneContainer) -> Void)?
}
