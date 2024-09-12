//
//  ContactDetailViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import UIKit

final class ContactDetailViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!

    var contact: ContactEntity?

    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.text = contact?.name
        lastName.text = contact?.lastName
    }
}

