//
//  ContactDetailsViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/09/24.
//

import UIKit

class ContactDetailsViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!

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
        firstName.text = contact?.name
        lastName.text = contact?.lastName
        title = "Detail"
        navigationController?.navigationBar.prefersLargeTitles = false


    }

}
