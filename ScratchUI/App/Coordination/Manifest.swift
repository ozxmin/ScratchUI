//
//  Manifest.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 19/02/25.
//

import Foundation

protocol ManifestProtocol {
    associatedtype Artifact
    associatedtype Dependencies

    typealias Module = (Self.Artifact, Self.Dependencies)
    var wirings: Module { get }

    var completion: ((any SceneContainer) -> Void)? { get set }
    init()
}

