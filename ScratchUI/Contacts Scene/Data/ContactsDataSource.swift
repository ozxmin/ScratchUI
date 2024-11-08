//
//  ContactDataManager.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import Foundation

final class ContactsDataSource {
    //TODO: - Get data fetching off main thread
    private lazy var sortedValues: [String: [ContactEntity]] = sortValues()
    private lazy var sortedSections: [String] = Array(sortedValues.keys.sorted())
    private var needsRefreshCounter = 0
    //TODO: - Define URL components and inject URL Components in Data Manager change set to random 1-4
}

// MARK: - Interface
extension ContactsDataSource {
    func getSortedSections() -> [String] {
        needsRefreshCounter += 1
        if needsRefreshCounter > 9 {
            log("needs refresh")
        }
        return sortedSections
    }

    func sectionsAndContactsSorted() -> [String: [ContactEntity]] {
        sortedValues
    }

    func getContact(at indexPath: IndexPath) -> ContactEntity {
        let sectionKey = getSortedSections()[indexPath.section]
        guard let contact = sectionsAndContactsSorted()[sectionKey]?[indexPath.row] else { fatalError(#function) }
        return contact
    }
}

// MARK: - Helpers
extension ContactsDataSource {
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
