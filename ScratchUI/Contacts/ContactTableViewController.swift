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
    let source = ContactDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        tableView.dataSource = source

        tableView.register(ContactTableCell.self, forCellReuseIdentifier: ContactTableCell.classID())
        view.backgroundColor = .systemOrange
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel(frame: .zero)
        header.text = source.sections[section]
        header.font = UIFont.boldSystemFont(ofSize: 20)
        header.backgroundColor = .systemGray
        return header
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        source.sections[section]
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
}

// MARK: -
class ContactDataSource: NSObject {
    private let dataManager: ContactDataManager
    private let contacts: Dictionary<String, [ContactEntity]>
    var sections: [String] {
        Array(contacts.keys)
    }

    override init() {
        dataManager = ContactDataManager()
        contacts = dataManager.mapToSections()
    }
}

// MARK: - UITableViewDataSource
extension ContactDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionIndex = sections[section]
        return contacts[sectionIndex]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableCell.classID(), for: indexPath)
        let sectionIndex = sections[indexPath.section]
        cell.textLabel?.text = contacts[sectionIndex]?[indexPath.row].name
        return cell
    }
} 
