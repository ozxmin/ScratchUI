//
//  ContactTableCell.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import UIKit

class ContactTableCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
}
