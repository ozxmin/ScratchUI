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

    var entity: ContactEntity?
    var contact: [(String, String)]?
    var contactMirror: Mirror?

    override func viewDidLoad() {
        super.viewDidLoad()
        additionalInfo?.delegate = self
        additionalInfo?.dataSource = self

        firstName.text = entity?.name
        lastName.text = entity?.lastName
        title = "Detail"

        guard let entity else { return }
        contactMirror = Mirror(reflecting: entity)
        contact = contactMirror?.children.compactMap { child in
            guard let label = child.label else { return nil }
            let textLabel = String(describing: label)
            let textValue = String(describing: child.value)

            return (textLabel, textValue)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Additional Information"
    }

    // MARK: - UITableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactMirror?.children.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        guard let (label, value) = contact?[indexPath.row] else {
            return cell
        }
        cell.textLabel?.text = "\(label): \(value)"
        return cell
    }
}
