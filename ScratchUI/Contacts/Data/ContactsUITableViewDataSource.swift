//
//  ContactsUITableViewDataSource.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 02/09/24.
//

import UIKit

// MARK: -
final class ContactsDataSource: NSObject {
    private let dataManager: ContactsDataManager
    private let contacts: Dictionary<String, [ContactEntity]>
    var sections: [String] {
        Array(contacts.keys.sorted())
    }

    override init() {
        dataManager = ContactsDataManager()
        contacts = dataManager.sortedAndKeyed()
        super.init()
    }
}

// MARK: - UITableViewDataSource
extension ContactsDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionIndex = sections[section]
        return contacts[sectionIndex]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableCell.classID(), for: indexPath)
        let sectionIndex = sections[indexPath.section]
        cell.textLabel?.text = contacts[sectionIndex]?[indexPath.row].name
        return cell
    }
}
