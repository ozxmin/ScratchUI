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
    private var isGridView = false

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
        navigationController?.isNavigationBarHidden = false

        let optionMenu = UIBarButtonItem(title: "Options", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menuItems())
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem = optionMenu
    }

    private func menuItems () -> UIMenu {
        let options = [
            UIAction(title: "Grid", image: UIImage(systemName: "square.grid.2x2"), handler: { [weak self] _ in
                self?.switchToCollectionView()
            }),
            UIAction(title: "Delete", image: UIImage (systemName: "trash"), attributes: .destructive) { _ in
                log("Delete") }
        ]
        let menu = UIMenu(title: "", options: .displayInline, children: options)
        return menu
    }

    private func switchToCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let itemWidth = (view.bounds.width - 40) / 3 // 3 items wide with 10 points spacing
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let collectionVC = ContactsCollectionViewController(collectionViewLayout: layout)
        navigationController?.setViewControllers([collectionVC], animated: true)
    }
}

// MARK: - TableViewDelegate
extension ContactsTableViewController {
    private func configureTableDelegates() {
        tableView.delegate = self
        tableView.dataSource = source
        tableView.register(ContactTableCell.self, forCellReuseIdentifier: ContactTableCell.id)
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
