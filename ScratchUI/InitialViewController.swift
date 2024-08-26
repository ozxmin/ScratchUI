//
//  ViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/08/24.
//

import UIKit

class InitialViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .magenta
        //configureAsViewController() //if self where UIViewController
        configureNavigationBar(with: self.navigationBar)
    }

    private func configureNavigationBar(with navigationBar: UINavigationBar) {
        navigationBar.prefersLargeTitles = true
        // You can customize colors if needed
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]

        // For iOS 13 and later, you can use the new appearance API
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }

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
//    let myInt: Int
//    init?(coder: NSCoder, anInt: Int) {
//        self.myInt = anInt
//        super.init(coder: coder)
//    }
//
//    init(myInt: Int) {
//        self.myInt = myInt
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    @available(*, unavailable)
//    convenience required init?(anInt: Int, aCoder: NSCoder) {
//        self.init(coder: aCoder)
//    }
//
//    required init?(coder: NSCoder) {
//        myInt = 1
//        super.init(coder: coder)
//    }
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
