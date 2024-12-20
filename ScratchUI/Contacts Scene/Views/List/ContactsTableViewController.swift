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
    func setContacts(contacts: [[ContactDisplay<Info.Basic>]])
    func setSections(sections: [String])
    func navigate(with contact: ContactDisplay<Info.Detailed>)
    func layout(with style: LayoutStyle)
}

typealias ContactsViewTC = UITableViewController & ContactsViewProtocol
final class ContactsTableViewController: ContactsViewTC {

    private var presenter: ContactsPresenterProtocol!
    private var contacts: [[ContactDisplay<Info.Basic>]] = []
    private var sections: [String] = []

    override func loadView() {
        super.loadView()
        self.presenter = ContactsPresenter(view: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
    }

    // TODO: - Fix loader view not shown in proper place
    private lazy var loaderView:
    UIActivityIndicatorView? = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.center = view.center
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)
        loader.centerXAnchor
            .constraint(equalTo: view.centerXAnchor).isActive = true
        loader.hidesWhenStopped = true

        return loader
    }()
}

// MARK: - View Conformance

extension ContactsTableViewController {
    func configureInitialView() {
        configureTableDelegates()
        configureNavigationBar()
    }

    func setTitle(_ title: String) {
        navigationItem.title = title
    }

    func setSections(sections: [String]) {
        self.sections = sections
    }
    
    func isLoading(shown: Bool) {
        shown ? showLoading() : dismissLoader()
    }

    func layout(with style: LayoutStyle) {
        if .grid ~= style {
            switchToCollectionView()
        }
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
        presenter?.onDidSelectItem(at: indexPath)
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
        navigationController?.isNavigationBarHidden = false
        let symbol = UIImage(systemName: "ellipsis.circle")
        let optionMenu = UIBarButtonItem(title: "Options", image: symbol, menu: menuItems())
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem = optionMenu
    }

    private func menuItems () -> UIMenu {
        let grid = UIImage(systemName: "square.grid.2x2")
        let trash = UIImage(systemName: "trash")
        let options = [
            UIAction(title: "Grid", image: grid, handler: { [weak self] action in
                log(action)
                self?.presenter?.onSwitchLayout()

            }),
            UIAction(title: "Delete", image: trash, attributes: .destructive) { _ in
                log("Delete")
            }
        ]

        let menu = UIMenu(title: "", options: .displayInline, children: options)
        return menu
    }

    private func switchToCollectionView() {
        let flowLayout = createCollectionFlowLayout()
        setCollectionView(layout: flowLayout)
    }

    private func setCollectionView(layout: UICollectionViewFlowLayout) {
        //let collectionVC = ContactsCollectionViewController(collectionViewLayout: layout)
        //navigationController?.setViewControllers([collectionVC], animated: true)
    }

    private func createCollectionFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let itemWidth = (view.bounds.width - 40) / 3 // 3 items wide with 10 points spacing
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }

}
