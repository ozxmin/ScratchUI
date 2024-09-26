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
    let exclusions = ["avatar", "id", "name", "lastName", "ethereumAddress"]

    let name: String
    let lastName: String
    let avatar: URL?
    var details: [(label: String, value: String)]

    init(entity: ContactEntity) {
        guard let entityAvatar = entity.avatar, let avatarURL = URL(string: entityAvatar) else {
            assert(false, "avator entity is nil")
        }

        avatar = avatarURL
        name = entity.firstName
        lastName = entity.lastName


        let contactMirror = Mirror(reflecting: entity)
        let reflection = contactMirror.reflectionToStrings(excluding: exclusions)

        details = reflection.map { item in
            return (Self.format(label: item.label), item.value)
        }
    }

    private static func format(label: String) -> String {
        assert(!label.isEmpty, "label should not be empty")

        // Insert a space before every uppercase letter, except the first one
        let formatted = label.reduce("") { result, character in
            if character.isUppercase {
                return result + " " + String(character)
            }
            return result + String(character)
        }
        // Capitalize the first letter and lowercase the rest
        return formatted.prefix(1).capitalized + formatted.dropFirst()
    }
}

extension Mirror {
    func reflectionToStrings(excluding excluded: [String]) -> [(label: String, value: String)] {

        let childToString = { (child: Child) -> (String, String)? in
            guard let label = child.label,
                  let optinalValue = child.value as? String? else {
                return nil
            }
            if excluded.contains(label) { return nil }
            let value = optinalValue ?? "---"
            return (label, value)
        }

        let labelValue = children.compactMap(childToString)

        return labelValue
    }

}
