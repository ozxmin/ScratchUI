//
//  ContactsTableDataSource.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 02/09/24.
//

import UIKit

final class ContactsTableDataSource: NSObject {
    private let dataManager: ContactsDataManager

    override init() {
        dataManager = ContactsDataManager()
        super.init()
    }
}

// MARK: - ContactsTableView
extension ContactsTableDataSource {
    func sections() -> [String] {
        dataManager.sortedSections()
    }

    func getDetailsDisplay<T>(for indexPath: IndexPath) -> ContactDisplay<T> {
        let contact = dataManager.getElement(at: indexPath)
        let details: ContactDisplay<T> = .init(contact)
        return details
    }
}

// MARK: - UITableViewDataSource
extension ContactsTableDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataManager.sortedContacts().count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        dataManager.sortedSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionIndex = dataManager.sortedSections()[section]
        return dataManager.sortedContacts()[sectionIndex]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactTableCell = tableView.dequeue(for: indexPath)
        let cell: ContactTableCell = tableView.dequeueItem(for: indexPath)
        let contact = dataManager.getElement(at: indexPath)
        cell.fillIn(with: contact)
        return cell
    }
}

extension UITableView {
    func dequeue<Cell: UITableViewCell>(for indexPath: IndexPath, cell: Cell? = nil) -> Cell {
        let cellid = Cell.identifier
        guard let cell = dequeueReusableCell(withIdentifier: cellid, for: indexPath) as? Cell else {
            fatalError(#function)
        }
        return cell
    }
}

