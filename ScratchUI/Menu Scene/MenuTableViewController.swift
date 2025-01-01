//
//  MenuTableViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import UIKit

protocol MenuViewProtocol {
    func bareLayout()
    func setTitle(_ title: String)
}

class MenuTableViewController: UITableViewController, MenuViewProtocol {
    var presenter: MenuPresenterInterface!
    let scenes = Coordinator.allCases

    convenience init(presenter: MenuPresenterInterface) {
        self.init()
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
    }

}

// MARK: - Helpers
extension MenuTableViewController {
    private func selectDemo(option: Coordinator) {
        guard let position = option.index else { return }
        let index = IndexPath(row: position, section: 0)
        tableView(tableView, didSelectRowAt: index)
    }
}

// MARK: - View Conformance
extension MenuTableViewController {

    func bareLayout() {
        configureBars()
        view.backgroundColor = .systemGroupedBackground
        selectDemo(option: .contacts)
    }

    func setTitle(_ title: String) {
        navigationItem.title = title
    }
}

// MARK: - Menu Appearance
extension MenuTableViewController {
    private func configureBars() {
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

// MARK: - Table delegates
extension MenuTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scene = scenes[indexPath.row]
        let screen = scene.create()
        show(screen, sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        scenes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.textProperties.font = .preferredFont(forTextStyle: .title2)
        content.textProperties.adjustsFontForContentSizeCategory = true

        content.text = scenes[indexPath.row].title

        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
