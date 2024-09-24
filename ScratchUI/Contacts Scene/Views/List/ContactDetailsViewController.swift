//
//  ContactDetailsViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/09/24.
//

import UIKit

class ContactDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var additionalInfo: UITableView!

    var contact: ContactEntity?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        additionalInfo?.delegate = self
        additionalInfo?.dataSource = self

        firstName.text = contact?.name
        lastName.text = contact?.lastName
        title = "Detail"
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - UITableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Static table with one section, modify as needed
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // Static number of rows, modify as needed
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        // Configure cell content for static cells
        switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Static Row 1"
            case 1:
                cell.textLabel?.text = "Static Row 2"
            case 2:
                cell.textLabel?.text = "Static Row 3"
            default:
                break
        }

        return cell
    }

    // MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection
    }


}
