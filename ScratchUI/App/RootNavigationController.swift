//
//  ViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/08/24.
//

import UIKit

final class RootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .magenta
        configureNavigationBar(with: navigationBar)
    }
    
    private func configureNavigationBar(with navigationBar: UINavigationBar) {
        navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
    }

    /// If self where UIViewController
    @available(*, renamed: "configureNavigationBar()")
    private func configureAsViewController() {
        let tableViewController = MenuTableViewController()
        let navigationController = UINavigationController(rootViewController: tableViewController)
        navigationController.view.backgroundColor = .yellow

        // Add the NavigationController as a child of the MainViewController
        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)

        configureNavigationBar(with: navigationController.navigationBar)
        // Make the NavigationController's view fill the MainViewController
        navigationController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
            navigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
