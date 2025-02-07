//
//  Coordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 06/02/25.
//

import Foundation

protocol CoordinatorProtocol: AnyObject {
    typealias AnyCoordinator = (any CoordinatorProtocol)
    associatedtype Screen

    var screen: Screen { get }
    var parentCoordinator: AnyCoordinator? { get set }
    func start()
    func wire()
}


class Coordinator<V, each T>: CoordinatorProtocol {

    var parentCoordinator: AnyCoordinator?
    var childCoordinators: [AnyCoordinator] = []

    let manifest: Manifest<V, repeat each T>
    lazy var screen: V = { manifest.wireElements() }()

    init(scene: Manifest<V, repeat each T>) {
        self.manifest = scene
    }

    func wire() { }
    func start() { }
}


class Manifest<V, each T> {
    let elements: () -> (V, (repeat each T))

    init(wirings elements: @escaping () -> (V, (repeat each T))) {
        self.elements = elements
    }

    func wireElements() -> V {
        elements().0
    }
}
