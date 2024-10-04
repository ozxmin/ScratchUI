//
//  ContactTableViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 21/08/24.
//

import UIKit

/**
 # TODO:
 - Instead of first name, chose another field to show in the table and sortby that field
 - Support re arranging cells (disables sorted alphabetically)
 - Support search filtering, desirably fuzzy match, and search all fields
 - add pull to refresh
 - Bar item toggle to show contacts as collection view with its profile pictures (pre fetched)
- Get all data fetching off main thread an then move the UI updates to main  thread
 - support sort alphabetically
 - support delete, add and modify
 - support swiftData persistance

*/

final class ContactsTableViewController: UITableViewController {
    private let source = ContactsTableDataSource()

    override func loadView() {
        super.loadView()
        configureTableDelegates()
        configureNavigationBar()
    }
}

// MARK: - Navigation Bar + Menu
extension ContactsTableViewController {
    private func configureNavigationBar() {
        title = "Contacts"
        tableView.backgroundColor = .systemGreen
        navigationController?.isNavigationBarHidden = false

        let optionMenu = UIBarButtonItem(title: "Options", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menuItems())
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem = optionMenu
    }

    @objc private func menuItems () -> UIMenu {
        let options = [
            UIAction (title: "Copy", image: UIImage (systemName: "doc") ) { _ in
                log("Copy") },
            UIAction (title: "Share", image: UIImage (systemName: "square.and.arrow.up")) { _ in
                log("Share") },
            UIAction (title: "Favorite", image: UIImage(systemName: "suit.heart")){ _ in
                log("Favorite") },
            UIAction (title: "Show All Photos", image: UIImage (systemName: "photo.on.rectangle")) { _ in
                log("Show All Photos") },
            UIAction(title: "Delete", image: UIImage (systemName: "trash"), attributes: .destructive) { _ in
                log("Delete") }
        ]
        let menu = UIMenu(title: "", options: .displayInline, children: options)
        return menu
    }
}

// MARK: - TableViewDelegate
extension ContactsTableViewController {
    private func configureTableDelegates() {
        tableView.delegate = self
        tableView.dataSource = source
        tableView.register(ContactTableCell.self, forCellReuseIdentifier: ContactTableCell.identifier)
    }

    // TODO: - Change implementation to use content configurator
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel(frame: .zero)
        header.text = source.sections()[section]
        header.font = UIFont.boldSystemFont(ofSize: 20)
        header.backgroundColor = .systemGray
        return header
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        source.sections()[section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: - Use coordinator instead
        let contactDetailVC = ContactDetailsViewController()
        let contact: ContactDisplay<Info.Detailed> = source.getDetailsDisplay(for: indexPath)
        contactDetailVC.detail = contact

        show(contactDetailVC, sender: nil)
    }
}
