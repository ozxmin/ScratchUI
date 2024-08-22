//
//  ContactTableViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 21/08/24.
//

import UIKit

class ContactTableViewController: UITableViewController {
    let dataSource = ContactDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
    }
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        tableView.backgroundColor = .blue
    }
}

class ContactDataSource: NSObject, UITableViewDataSource {
    let content = ["uno", "dos", "tres", "cuatro", "cinco"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        content.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()

        cell.textLabel?.text = content[indexPath.item]
        return cell
    }
}


struct ContactEntity {
    let id: Int
    let name: String
    let lastName: String
    let phone: String
    let avatar: String
    let address: String
    let email: String
    let dateAdded: String
}

