//
//  ContactTableCell.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import UIKit

final class ContactTableCell: UITableViewCell {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    var content: UIListContentConfiguration?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        setListConfiguration()
    }

    private func setListConfiguration() {
        content = defaultContentConfiguration()
        content?.textProperties.color = .black
        contentConfiguration = content
    }

    func fillIn(with contact: ContactEntity) {
        content?.attributedText = styleBoldAndNormal(bold: contact.name, normal: contact.lastName)
        contentConfiguration = content
    }

    private func styleBoldAndNormal(bold: String, normal: String) -> NSAttributedString {
        let boldAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        let normalAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]

        let boldWord = NSMutableAttributedString(string: bold, attributes: boldAttribute)
        let normalWord = NSMutableAttributedString(string: " \(normal)", attributes: normalAttribute)
        boldWord.append(normalWord)
        return boldWord
    }
}
