//
//  ContactDataManager.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import Foundation

final class ContactsDataManager {
    // TODO: - Get data fetching off main thread
    private lazy var contacts = sortedAndKeyed()
    private lazy var storedSectionsSorted: [String] = Array(contacts.keys.sorted())
    private var needsRefreshCounter = 0
}

//Interface
extension ContactsDataManager {
    func sortedSections() -> [String] {
        if needsRefreshCounter > 9 {
            log("needs refresh")
        }
        return storedSectionsSorted
    }

    func sortedContacts() -> [String : [ContactEntity]] {
        contacts
    }

    func getElement(at indexPath: IndexPath) -> ContactEntity {
        let currentSection = storedSectionsSorted[indexPath.section]
        guard let contact = contacts[currentSection]?[indexPath.row] else { fatalError(#function) }
        return contact
    }
}

//Helpers
extension ContactsDataManager {
    private func sortedAndKeyed() -> Dictionary<String, [ContactEntity]> {
        let alphabetically = decodeJsonData().sorted { $0.firstName < $1.firstName }
        let grouped = Dictionary(grouping: alphabetically) { String($0.firstName.first?.uppercased() ?? "#") }
        return grouped
    }

    private func unsortedKeys() -> Dictionary<String, [ContactEntity]> {
        let array = decodeJsonData()
        let grouped = Dictionary(grouping: array) { String($0.firstName.first?.uppercased() ?? "#") }
        return grouped
    }

    private func decodeJsonData() -> [ContactEntity] {
        let contacts: [ContactEntity] = Bundle.main.decode("contacts_mock_data")
        return contacts
    }
}
