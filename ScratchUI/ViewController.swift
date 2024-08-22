//
//  ViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/08/24.
//

import UIKit

class ViewController: UITableViewController {
    let myInt: Int

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View controller loaded")
        // Do any additional setup after loading the view.

        tableView.register(MyCell.self,
                           forCellReuseIdentifier: MyCell.cellReuseIdentifier)

        tableView.backgroundColor = .green
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did")
    }

    func setLayout() {
//        additionalSafeAreaInsets
//        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
//        let widthConstraint = NSLayoutConstraint(item: self.noEatNowProductsMessageView,
//                                                 attribute: .width,
//                                                 relatedBy: NSLayoutConstraint.Relation.equal,
//                                                 toItem: self.view,
//                                                 attribute: .width,
//                                                 multiplier: 1,
//                                                 constant: 0)

//        NSLayoutConstraint.activate([
//            scannerView.topAnchor.constraint(equalTo: scannerContainerView.topAnchor),
//            scannerView.bottomAnchor.constraint(equalTo: scannerContainerView.bottomAnchor),
//            scannerView.leadingAnchor.constraint(equalTo: scannerContainerView.leadingAnchor),
//            scannerView.trailingAnchor.constraint(equalTo: scannerContainerView.trailingAnchor)
//        ])
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        // Fetch Image
//        let image = dataSource[indexPath.row]
//        // Show Image
//        showImage(image)
    }

}

extension ViewController {
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
