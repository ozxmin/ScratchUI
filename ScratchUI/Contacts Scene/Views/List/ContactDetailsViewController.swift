//
//  ContactDetailsViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/09/24.
//

import UIKit
import SwiftUI

/* TODO: - the property detail is acting as a data source. Asking for updated data wouldn't work. Remove the detail property and use a proper data source. Title should be in the DisplayObject */

class ContactDetailsViewController: UIViewController {
    @IBOutlet weak var avatarHolder: UIView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var additionalInfo: UITableView!
    var detail: ContactDisplay<Info.Detailed>?
    var data: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        if detail != nil {
            fillInfo(with: detail!)
        }
        additionalInfo?.delegate = self
        additionalInfo?.dataSource = self
    }

    private func fillInfo(with contact: ContactDisplay<Info.Detailed>) {
        firstName.text = contact.name
        lastName.text = contact.lastName
        Task {
            printQ(1)
            let url = contact.getImageURL()
            if let imageData = await fetchData(from: url) {
                printQ(2)
                self.data = imageData
                createAvatar(from: imageData)
            }
        }
    }

    private func createAvatar(from data: Data) {
        let imageView = UIImageView(image: UIImage(data: data))
        let imageSize = avatarHolder.frame.height
        imageView.frame.size = CGSize(width: imageSize, height: imageSize)
        imageView.applyCircleMask()
        imageView.center = avatarHolder.center
        avatarHolder.addSubview(imageView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTap))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }

    @MainActor
    @objc func avatarTap() {
        if let data, let detail {
            let swiftUIView = AvatarImageView(placeholder: data, details: detail)
            let hostingController = UIHostingController(rootView: swiftUIView)
            show(hostingController, sender: nil)
        }
    }

    //TODO: - This method dosent belong in a view
    private func fetchData(from url: URL?) async -> Data? {
        guard let url else { return nil }
        printQ(3)
        let response = try? await URLSession.shared.data(for: URLRequest(url: url))
        printQ(4)
        return response?.0
    }
}

// MARK: - UITableViewDataSource methods
extension ContactDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Additional Information"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detail?.details?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let (label, value) = detail?.details?[indexPath.row] else {
            return cell
        }
        cell.textLabel?.text = "\(label): \(value)"
        return cell
    }
}
