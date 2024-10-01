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
        title = "Detail"
        fillInfo(with: detail!)
        additionalInfo?.delegate = self
        additionalInfo?.dataSource = self
    }

    private func fillInfo(with contact: ContactDetailsDisplay) {
        //avatarImage.image = contact.avatar
        firstName.text = contact.name
        lastName.text = contact.lastName
        guard let url = contact.avatarURL else {
            return
        }
        Task {
            let imageData = await fetchData(from: url)
            avatarImage.image = UIImage(data: imageData!)
        }
    }

    func fetchData(from url: URL) async -> Data? {
        do {
            let response = try? await URLSession.shared.data(for: URLRequest(url: url))
            if let data = response?.0 {
                return data
            }
            return nil
        }
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
