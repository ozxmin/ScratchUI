//
//  ContactDataManager.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import Foundation

final class ContactsDataManager {
    //TODO: - Get data fetching off main thread
    private lazy var contacts: [String : [ContactEntity]] = sortValues()
    private lazy var sectionsSorted: [String] = Array(contacts.keys.sorted())
    private var needsRefreshCounter = 0
    //TODO: - Define URL components and inject URL Components in Data Manager change set to random 1-4
}

// MARK: - Interface
extension ContactsDataManager {
    func sortedSections() -> [String] {
        if needsRefreshCounter > 9 {
            log("needs refresh")
        }
        return sectionsSorted
    }

    func sortedContacts() -> [String : [ContactEntity]] {
        contacts
    }

    func getElement(at indexPath: IndexPath) -> ContactEntity {
        let currentSection = sortedSections()[indexPath.section]
        guard let contact = sortedContacts()[currentSection]?[indexPath.row] else { fatalError(#function) }
        return contact
    }
}

// MARK: - Helpers
extension ContactsDataManager {
    private func sortValues() -> Dictionary<String, [ContactEntity]> {
        let alphabetically = decodeJsonData().sorted { $0.firstName < $1.firstName }
        let grouped = Dictionary(grouping: alphabetically) { String($0.firstName.first?.uppercased() ?? "#") }
        return grouped
    }

    private func rawDictionary() -> Dictionary<String, [ContactEntity]> {
        let array = decodeJsonData()
        let grouped = Dictionary(grouping: array) { String($0.firstName.first?.uppercased() ?? "#") }
        return grouped
    }

    private func decodeJsonData() -> [ContactEntity] {
        let contacts: [ContactEntity] = Bundle.main.decode("contacts_mock_data")
        return contacts
    }
}
