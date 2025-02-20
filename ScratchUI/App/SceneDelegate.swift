//
//  SceneDelegate.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/08/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    lazy var appCoordinator: Coordinator<RootNavigationController> = .init()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        configWindow(scene, setRoot: appCoordinator.screen)
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

// Fix tying RootNavigationController to Module
// create wrapper to easily make Modules
extension RootNavigationController: ManifestProtocol {
    typealias Artifact = RootNavigationController
    typealias Dependencies = Void
    var wirings: Module {
        (self, ())
    }
    var completion: ((any SceneContainer) -> ())? {
        get {  return { _ in } }
        set { }
    }
}
