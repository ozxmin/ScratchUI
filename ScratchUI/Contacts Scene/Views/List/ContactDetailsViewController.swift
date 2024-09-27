//
//  ContactDetailsViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/09/24.
//

import UIKit

/* TODO: - the property detail is acting as a data source. Asking for updated data wouldn't work. Remove the detail property and use a proper data source. Title should be in the DisplayObject */

class ContactDetailsViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var additionalInfo: UITableView!
    var detail: ContactDetailsDisplay?

    override func viewDidLoad() {
        super.viewDidLoad()
        additionalInfo?.delegate = self
        additionalInfo?.dataSource = self
        title = "Detail"
        fillInfo(with: detail!)
    }

    private func fillInfo(with contact: ContactDetailsDisplay) {
        //avatarImage.image = contact.avatar
        firstName.text = contact.name
        lastName.text = contact.lastName
    }
}

// MARK: - UITableViewDataSource methods
extension ContactDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Additional Information"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detail?.details.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        guard let (label, value) = detail?.details[indexPath.row] else {
            return cell
        }
        cell.textLabel?.text = "\(label): \(value)"
        return cell
    }
}
