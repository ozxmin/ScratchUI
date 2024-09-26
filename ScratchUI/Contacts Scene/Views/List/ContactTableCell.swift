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
        content?.textProperties.color = UIColor.label
        contentConfiguration = content
    }

    func fillIn(with contact: ContactEntity) {
        content?.attributedText = styleBoldAndNormal(bold: contact.firstName, normal: contact.lastName)
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

//func bind<Model>(title: KeyPath<Model, String>, model: Model) {
//    self.textLabel?.text = model[keyPath: title]
//}
//
//struct CellConfigurator<Model> {
//    let title: KeyPath<Model, String>
//    let subtitle: KeyPath<Model, String>
//
//    func configure(_ cell: UITableViewCell, for model: Model) {
//        cell.textLabel?.text = model[keyPath: title]
//        cell.detailTextLabel?.text = model[keyPath: subtitle]
//
//    }
//}
//
//func set() {
//    let configurator = Configurator<ContactEntity>(\.name, \.lastName)
//}
//
//func setUI(config: Configurator<some Any>) {
//    textLabel?.text = config.name
//}
//
//struct Configurator<Model> {
//    let name: KeyPath<Model, String>
//    let lastName: KeyPath<Model, String>
//    init(_ name: KeyPath<Model, String>, _ lastName: KeyPath<Model, String>) {
//        self.name = name
//        self.lastName = lastName
//    }
//}
