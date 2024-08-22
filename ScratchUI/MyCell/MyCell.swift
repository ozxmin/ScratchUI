//
//  MyCell.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 05/08/24.
//

import UIKit

class MyCell: UITableViewCell {

    static var cellReuseIdentifier: String {
        //typeID
        "MyCell"
    }

    static var nib: UINib {
        //Your app should use UINib objects whenever it needs to repeatedly instantiate the same nib data. For example, if your table view uses a nib file to instantiate table view cells, caching the nib in a UINib object can improve performance.
        return UINib(nibName: String(describing: self), bundle: Bundle(identifier: "main"))
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

}

