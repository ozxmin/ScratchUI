//
//  ViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/08/24.
//

import UIKit

final class InitialViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .magenta

        configureNavigationBar(with: self.navigationBar)
        self.toolbarItems = [
            UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menuItems()),
            UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menuItems())
        ]

    }

    func menuItems () -> UIMenu {
        let addMenuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction (title: "Copy", image: UIImage (systemName: "doc") ) { (_) in
                print ("Copy")
            },
            UIAction (title: "Share", image: UIImage (systemName: "square.and.arrow.up")) { (_) in
                print ("Share")
            },
            UIAction (title: "Favorite", image: UIImage(systemName: "suit.heart")){ （_） in
                print ("Favorite")
            },
            UIAction (title: "Show All Photos", image: UIImage (systemName: "photo.on.rectangle")) { (_) in
                print ("Show All Photos")
            },
            UIAction(title: "Delete", image: UIImage (systemName: "trash"), attributes: .destructive) { (_) in
                print ("Delete")
            }])
        return addMenuItems
    }

    private func configureNavigationBar(with navigationBar: UINavigationBar) {
        navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance

    }

    /// If self where UIViewController
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

extension InitialViewController {
    private func loadXib() {
//        let nib = UINib(nibName: "HealthQuestionnaireView", bundle: bundle)
//        if let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView {
//            nibView.translatesAutoresizingMaskIntoConstraints = false
//            view.backgroundColor = UIColor.clear
//            view.addSubview(nibView)
//            nibView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//            nibView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//            nibView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//            nibView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        }
    }
}
