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
    let contacts: Dictionary<String, [ContactEntity]>
    var sortedSections: [String] {
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
        sortedSections.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sortedSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionIndex = sortedSections[section]
        return contacts[sectionIndex]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: ContactTableCell = tableView.dequeue(for: indexPath)

        let currentSection = sortedSections[indexPath.section]
        guard let contact = contacts[currentSection]?[indexPath.row] else { fatalError() }

        let conf = CellConfigurator<ContactEntity>(title: \.name, subtitle: \.lastName)
        conf.configure(cell, for: contact)


        cell.fillIn(with: contact)
        return cell
    }
}


extension UITableView {
    func dequeue<Cell: UITableViewCell>(for indexPath: IndexPath, cell: Cell? = nil) -> Cell {
        let cellid = Cell.classID()
        guard let cell = dequeueReusableCell(withIdentifier: cellid, for: indexPath) as? Cell else {
            fatalError(#function)
        }
        return cell
    }
}

