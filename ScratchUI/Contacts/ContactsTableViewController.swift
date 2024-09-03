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
 - Bar item toggle to show contacts as collection view with its profile pictures (pre fetched)
- Get all data fetching off main thread an then move the UI updates to main thread
 */


/// #Markdown
final class ContactsTableViewController: UITableViewController {
    private let source = ContactDataSource()

    override func loadView() {
        super.loadView()
        title = "Contacts"
        tableView.dataSource = source

        tableView.register(ContactTableCell.self, forCellReuseIdentifier: ContactTableCell.classID())
        tableView.backgroundColor = .systemGreen
    }
}

// MARK: - TableViewDelagate
extension ContactsTableViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel(frame: .zero)
        header.text = source.sections[section]
        header.font = UIFont.boldSystemFont(ofSize: 20)
        header.backgroundColor = .systemGray
        return header
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        source.sections[section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let childVC = ContactDetailViewController()
        show(childVC, sender: nil)
    }
}
