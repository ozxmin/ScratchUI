//
//  ViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/08/24.
//

import UIKit

class InitialViewController: UINavigationController, UINavigationBarDelegate, UINavigationControllerDelegate {
    let myInt: Int

    override func loadView() {
        super.loadView()

//        let menuVC = MenuTableViewController()
//        addChild(menuVC)

//        menuVC.didMove(toParent: self)
//        delegate = menuVC
        delegate = self
//        navigationBar.delegate = self
        view.backgroundColor = .orange
        navigationItem.title = "Initial1"
        navigationBar.largeContentTitle = "Intit 2"
        title = "Init 3"
        
        configureNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configureNavigationBar() {
        navigationItem.title = "Initial"
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: view.topAnchor),
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        navigationBar.prefersLargeTitles = true // This gives a modern iOS look

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
    init?(coder: NSCoder, anInt: Int) {
        self.myInt = anInt
        super.init(coder: coder)
    }

    init(myInt: Int) {
        self.myInt = myInt
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    convenience required init?(anInt: Int, aCoder: NSCoder) {
        self.init(coder: aCoder)
    }

    required init?(coder: NSCoder) {
        myInt = 1
        super.init(coder: coder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will")
    }
}

extension InitialViewController {
    func loadXib() {
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
