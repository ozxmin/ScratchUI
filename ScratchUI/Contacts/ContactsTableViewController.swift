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
    private let source = ContactsDataSource()

    override func loadView() {
        super.loadView()
        title = "Contacts"

        configureTableDelagete()
        configureNavigationBar()
    }

    private func configureTableDelagete() {
        tableView.dataSource = source
        tableView.register(ContactTableCell.self, forCellReuseIdentifier: ContactTableCell.classID())
        tableView.backgroundColor = .systemGreen
    }
}

// MARK: - Navigation Bar
extension ContactsTableViewController {
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        let optionMenu = UIBarButtonItem(title: "Options", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menuItems())
        navigationItem.rightBarButtonItem = optionMenu
    }

    @objc private func menuItems () -> UIMenu {
        let options = [
            UIAction (title: "Copy", image: UIImage (systemName: "doc") ) { _ in
                print ("Copy") },
            UIAction (title: "Share", image: UIImage (systemName: "square.and.arrow.up")) { _ in
                print ("Share") },
            UIAction (title: "Favorite", image: UIImage(systemName: "suit.heart")){ _ in
                print ("Favorite") },
            UIAction (title: "Show All Photos", image: UIImage (systemName: "photo.on.rectangle")) { _ in
                print ("Show All Photos") },
            UIAction(title: "Delete", image: UIImage (systemName: "trash"), attributes: .destructive) { _ in
                print ("Delete") }
        ]
        let menu = UIMenu(title: "", options: .displayInline, children: options)
        return menu
    }
}

// MARK: - TableViewDelagate
extension ContactsTableViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel(frame: .zero)
        header.text = source.sortedSections[section]
        header.font = UIFont.boldSystemFont(ofSize: 20)
        header.backgroundColor = .systemGray
        return header
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        source.sortedSections[section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let childVC = ContactDetailViewController()
        show(childVC, sender: nil)
    }
}
