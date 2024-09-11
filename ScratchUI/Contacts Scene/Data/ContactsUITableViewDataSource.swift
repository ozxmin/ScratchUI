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
    var sortedSections: [String] {
        dataManager.sortedSections
    }
    var contacts: [String: [ContactEntity]] {
        dataManager.contacts
    }
    
    override init() {
        dataManager = ContactsDataManager()
        super.init()
    }
}

// MARK: - UITableViewDataSource
extension ContactsDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataManager.contacts.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        dataManager.sortedSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionIndex = dataManager.sortedSections[section]
        return dataManager.contacts[sectionIndex]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactTableCell = tableView.dequeue(for: indexPath)
        let contact = dataManager.getElement(at: indexPath)

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

