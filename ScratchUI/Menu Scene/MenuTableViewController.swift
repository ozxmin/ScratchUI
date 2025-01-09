//
//  MenuTableViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import UIKit

protocol MenuViewProtocol {
    func bareLayout()
    func setState(state: MenuPresenter.ViewState)
}

class MenuTableViewController: UITableViewController, MenuViewProtocol {
    var presenter: MenuPresenterInterface!
    var state: MenuPresenter.ViewState! //<T: Presenter> T.State

    convenience init(presenter: MenuPresenterInterface) {
        self.init()
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
    }
}

// MARK: - View Conformance
extension MenuTableViewController {
    func setState(state: MenuPresenter.ViewState) {
        self.state = state
    }

    func bareLayout() {
        navigationItem.title = state.title
        view.backgroundColor = .systemGroupedBackground
        configureBarButtons()
    }
}

// MARK: - Table delegates
extension MenuTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.onDidTapItem(at: indexPath)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        state.options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.textProperties.font = .preferredFont(forTextStyle: .title2)
        content.textProperties.adjustsFontForContentSizeCategory = true

        content.text = state.options[indexPath.row].title

        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - Menu Appearance
extension MenuTableViewController {
    private func configureBarButtons() {
        navigationController?.isNavigationBarHidden = false

        let optionMenu = UIBarButtonItem(title: "Options", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menuItems())
        navigationItem.rightBarButtonItem = optionMenu
    }

    func menuItems () -> UIMenu {
        let addMenuItems = UIMenu(title: "", options: .displayAsPalette, children: [
            UIAction (title: "Copy", image: UIImage (systemName: "doc") ) { (_) in
                log("Copy")
            },
            UIAction (title: "Share", image: UIImage (systemName: "square.and.arrow.up")) { (_) in
                log("Share")
            }])
        return addMenuItems
    }
}
