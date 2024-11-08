//
//  ContactTableViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 21/08/24.
//

import UIKit

protocol ContactsViewProtocol {
    func configureInitialView()
    func setTitle(_ title: String)
    func isLoading(shown: Bool)
    func navigate(with contact: ContactDisplay<Info.Detailed>)
    func layout(with style: LayoutStyle)
    func setSections(sections: [String])
    func setContacts(contacts: [[ContactDisplay<Info.Basic>]])
}

final class ContactsTableViewController: UITableViewController, ContactsViewProtocol {

    var presenter: ContactsPresenterProtocol?

    private lazy var loaderView: UIActivityIndicatorView? = {
        let loaderView = UIActivityIndicatorView(style: .large)
        loaderView.center = view.center
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(loaderView)

        loaderView.hidesWhenStopped = true

        return loaderView
    }()

    // make a custom data struct that acts as an array. Takes a subscript and returns that element. Elements are served on-demand, instead of setting all elements at once
    private var sections: [String] = []
    private var contacts: [[ContactDisplay<Info.Basic>]] = []

    override func loadView() {
        super.loadView()
        presenter?.onViewDidLoad()
    }
}

// MARK: - View Conformance

extension ContactsTableViewController {
    func isLoading(shown: Bool) {
        shown ? showLoading() : dismissLoader()
    }

    func layout(with style: LayoutStyle) {
        if case .grid = style {
            switchToCollectionView()
        }
    }

    func setSections(sections: [String]) {
        self.sections = sections
    }

    func setContacts(contacts: [[ContactDisplay<Info.Basic>]]) {
        self.contacts = contacts
    }

    private func showLoading() {
        loaderView?.startAnimating()
        view.isUserInteractionEnabled = false
    }

    private func dismissLoader() {
        loaderView?.stopAnimating()
        view.isUserInteractionEnabled = true
    }

    func configureInitialView() {
        configureTableDelegates()
        configureNavigationBar()
    }
    
    func setTitle(_ title: String) {
        navigationItem.title = title
    }

    func navigate(with contact: ContactDisplay<Info.Detailed>) {
        let contactDetailVC = ContactDetailsViewController()
        contactDetailVC.detail = contact

        show(contactDetailVC, sender: nil)
    }
}

// MARK: - TableViewDelegate
extension ContactsTableViewController {
    private func configureTableDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactTableCell.self, forCellReuseIdentifier: ContactTableCell.id)
    }

    // TODO: - Change implementation to use content configurator
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel(frame: .zero)
        header.text = sections[section]
        header.font = UIFont.boldSystemFont(ofSize: 20)
        header.backgroundColor = .systemGray
        return header
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: - Use coordinator//router instead for navigating
        presenter?.didSelectItem(at: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension ContactsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: - Improve ergonomics on dequeueable items
        // Just tell line 41 to verbose
        // maybe just tell the info level (or the type: ContactTableCell)and it adapts what data is needed
        let contact: ContactDisplay<Info.Basic> = contacts[indexPath.section][indexPath.row]
        let cell: ContactTableCell = tableView.dequeueItem(for: indexPath)

        cell.fillIn(with: contact)

        return cell
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
            UIAction(title: "Grid", image: UIImage(systemName: "square.grid.2x2"), handler: { [weak self] action in
                self?.presenter?.switchLayout()

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
