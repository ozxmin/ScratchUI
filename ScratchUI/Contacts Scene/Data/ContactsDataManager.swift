//
//  ContactDataManager.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import Foundation

final class ContactsDataManager {
    // TODO: - Get off main thread
    lazy var contacts = sortedAndKeyed()
    var sortedSections: [String] {
        Array(sortedAndKeyed().keys.sorted())
    }

    func getElement(at indexPath: IndexPath) -> ContactEntity {
        let currentSection = sortedSections[indexPath.section]
        guard let contact = contacts[currentSection]?[indexPath.row] else { fatalError(#function) }
        return contact
    }

    private func unsortedKeys() -> Dictionary<String, [ContactEntity]> {
        let array = decodeJsonData()
        let grouped = Dictionary(grouping: array) { String($0.name.first?.uppercased() ?? "#") }
        return grouped
    }

    private func sortedAndKeyed() -> Dictionary<String, [ContactEntity]> {
        let alphabetically = decodeJsonData().sorted { $0.name < $1.name }
        let grouped = Dictionary(grouping: alphabetically) { String($0.name.first?.uppercased() ?? "#") }
        return grouped
    }

    private func decodeJsonData() -> [ContactEntity] {
        let contacts: [ContactEntity] = Bundle.main.decode("contacts_mock_data")
        return contacts
    }
}


struct ContactEntity: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let lastName: String
    let phone: String
    let avatar: String
    let address: String
    let email: String
    let dateAdded: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "first_name"
        case lastName = "last_name"
        case phone
        case avatar
        case address
        case email
        case dateAdded = "date_added"
    }
}

