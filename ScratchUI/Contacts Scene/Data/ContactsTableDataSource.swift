//
//  ContactsTableDataSource.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 02/09/24.
//

import UIKit

// MARK: -
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

    func contactDetails(for indexPath: IndexPath) -> ContactDetailsDisplay {
        let contact = dataManager.getElement(at: indexPath)
        let details = ContactDetailsDisplay(entity: contact)
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

struct ContactDetailsDisplay {
    let name: String
    let lastName: String
    let avatar: URL?
    let details: [(label: String, value: String?)]
    init(entity: ContactEntity) {
        name = entity.name
        lastName = entity.lastName

        guard let avatar = entity.avatar, let avatarURL = URL(string: avatar) else {
            assert(false, "avator entity is nil")
        }
        self.avatar = avatarURL

        let contactMirror = Mirror(reflecting: entity)

        let labelValue = contactMirror.children.compactMap { child -> (String, String)? in
            guard let label = child.label else { return nil }
            switch label {
                case "avatar", "id", "name", "lastName": return nil
                default: break
            }

            let textLabel = String(describing: label)
            let textValue = String(describing: child.value)

            return (textLabel, textValue)
        }
        details = labelValue
    }

}
