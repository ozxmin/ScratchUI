//
//  Coordinator+UIKit.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 19/02/25.
//

import UIKit

extension Coordinator {
    func request<T>(navigateTo child: Coordinator<T>) {
        switch (parent, children.isEmpty) {
            case (.none, true): handleNavigation(navigator: screen, childScreen: child)
            case (.none, false): push(navigator: screen, childScreen: child)
            case (.some, _): parent?.request(navigateTo: child)
        }
    }

    func push<T>(navigator: Scene.Artifact, childScreen: Coordinator<T>) {
        let (navigator, vc) = cast(navigator: navigator, vc: childScreen)
        navigator.show(vc, sender: nil)
    }

    func handleNavigation<T>(navigator: Scene.Artifact, childScreen: Coordinator<T>) {
        let (navigator, vc) = cast(navigator: navigator, vc: childScreen)
        navigator.setViewControllers([vc], animated: false)
    }

    private func cast<T>(navigator: Scene.Artifact, vc: Coordinator<T>) -> (UINavigationController, UIViewController) {
        guard let navigatorVC = screen as? UINavigationController,
              let childScreen = vc.screen as? UIViewController else {
            preconditionFailure("casting should be possible")
        }
        return (navigatorVC, childScreen)
    }
}
