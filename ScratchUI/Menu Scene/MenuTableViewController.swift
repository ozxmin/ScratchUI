//
//  MenuTableViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import UIKit

class MenuTableViewController: UITableViewController {

//    let items: KeyValuePairs<String, UIViewController.Type> = ["Contacts": ContactTableViewController.self]
    let demos = Demos.allCases

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        title = "Menu"
        configureBars()
//        selectDemo(option: .contacts)
    }

    func selectDemo(option: Demos) {
        guard let position = option.index() else {
            return
        }
        tableView(tableView, didSelectRowAt: IndexPath(row: position, section: 0))
    }


// MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        demos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let name = demos[indexPath.row].rawValue.name
        cell.textLabel?.text = name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigationController?.pushViewController(ContactTableViewController(), animated: true)
//        show(ContactTableViewController(), sender: nil)
        let screen = demos[indexPath.row].rawValue.screen.init()
        show(screen, sender: nil)
    }

}


// MARK: - Appearance

extension MenuTableViewController {
    private func configureBars() {
        navigationController?.isNavigationBarHidden = false

        let optionMenu = UIBarButtonItem(title: "Options", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menuItems())
        navigationItem.rightBarButtonItem = optionMenu
    }

    func menuItems () -> UIMenu {
        let addMenuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction (title: "Copy", image: UIImage (systemName: "doc") ) { (_) in
                print ("Copy")
            },
            UIAction (title: "Share", image: UIImage (systemName: "square.and.arrow.up")) { (_) in
                print ("Share")
            }])
        return addMenuItems
    }

}
