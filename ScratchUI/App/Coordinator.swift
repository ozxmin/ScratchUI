//
//  Coordinator.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 06/02/25.
//

import Foundation

protocol CoordinatorProtocol {
    associatedtype Screen where Screen == Self.Screen
    associatedtype Parent: CoordinatorProtocol

    var screen: Screen { get }
    var parentCoordinator: Parent? { get set }
    func start()
}

class Coordinator<V, each T>: CoordinatorProtocol {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator]?

    let manifest: Manifest<V, repeat each T>
    lazy var screen: V = { manifest.wireElements }()

    init(scene: Manifest<V, repeat each T>) {
        self.manifest = scene
    }

    func start() { }
}

class Manifest<V, each T> {
    typealias Components = (V, (repeat each T))
    let elements: () -> Components
    var wireElements: V { elements().0 }

    init(wirings elements: @escaping () -> Components) {
        self.elements = elements
    }
}
