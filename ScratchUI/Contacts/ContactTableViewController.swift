//
//  ContactTableViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 21/08/24.
//

import UIKit

/**
 TODO: 
 - support sort alphabetically
 - support delete, add and modify
 - support swiftData persistance
 - Instead of first name, chose another field to show in the table and sortby that field
 - Support re arrenging cells (disables sorted alphabetically)
 - Support search filtering, desireably fuzzy match, and search all fields
 - add pull to refresh

 */

class ContactTableViewController: UITableViewController {
    let dataSource = ContactDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.register(ContactTableCell.self, forCellReuseIdentifier: ContactTableCell.classID())
        view.backgroundColor = .magenta
        title = "Contacts"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let childVC = UIViewController(nibName: "ContactDetailViewController", bundle: nil)
        let childVC = ContactDetailViewController()

//        childVC.modalPresentationStyle = .fullScreen
//        childVC.modalTransitionStyle = .crossDissolve
//        addChild(childVC)
//        view.addSubview(childVC.view)
//        childVC.didMove(toParent: self)

        show(childVC, sender: nil)
        //showDetailViewController(childVC, sender: nil)
        //present(childVC, animated: true, completion: nil)
        ///Not working performing segue. Why?
        // performSegue(withIdentifier: "ContactDetailViewController", sender: self)
    }
    deinit {
        print("deinit ContactTableViewController")
    }
}

// MARK: -
class ContactDataSource: NSObject {
    let dataManager: ContactDataManager
    let contacts: [ContactEntity]
    override init() {
        dataManager = ContactDataManager()
        contacts = dataManager.getData()
    }

}

// MARK: - UITableViewDataSource
extension ContactDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableCell.classID(), for: indexPath)
        cell.textLabel?.text = contacts[indexPath.item].name
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension ContactDataSource: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //preload items at specified index
    }
}
