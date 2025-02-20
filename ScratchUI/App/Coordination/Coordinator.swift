//
//  Coordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 06/02/25.
//

import Foundation

protocol SceneContainer: AnyObject {
    func request<T>(navigateTo scene: Coordinator<T>)
    var parent: SceneContainer? { get set }
    var children: [SceneContainer] { get }
    func start()
}

final class Coordinator<Scene: ManifestProtocol>: SceneContainer {
    var parent: SceneContainer?
    var children: [SceneContainer] = []
    var scene: Scene
    lazy var screen: Scene.Artifact = { scene.wirings.0 }()

    convenience init() {
        self.init(module: Scene())
    }

    init(module: Scene) {
        self.scene = module
        scene.completion = navFlow(_:)
    }

    func navFlow(_ flow: any SceneContainer) {
        let coordinator = flow
        coordinator.parent = self
        children.append(coordinator)
        coordinator.start()
    }

    func start() {
        parent?.request(navigateTo: self)
    }

    func didFinish(child: Coordinator) {
        guard let childIndex = children
            .firstIndex(where: { $0 === child }) else {
            return
        }
        self.children.remove(at: childIndex)
    }
}
