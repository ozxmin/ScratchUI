//
//  ContactsDataManager.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 18/10/24.
//

import Foundation

// MARK: - Contacts Table DataSource
// TODO: Define URL components and inject URL Components in Data Manager change set to random 1-4
// TODO: - Don't use ui specific terms in the datasource

protocol ContactsDataManagerProtocol {
    func getContactEntities() -> [ContactEntity]
}


final class ContactsDataManager: ContactsDataManagerProtocol  {
    let contactsURI = "contacts_mock_data"
    var dataSource: ContactsDataSource
    lazy var cachedData: [ContactEntity] = fetchData()

    init() {
        dataSource = ContactsDataSource()
    }
}

extension ContactsDataManager {
    func fetchData() -> [ContactEntity] {
        dataSource.getData(from: contactsURI)
    }

    func getContactEntities() -> [ContactEntity] {
        cachedData
    }

    func sortData() {
        // memoization
        //maybe use lazy sequencing ie: array.lazy.map
        var contacts: [ContactEntity] = []
        contacts.reserveCapacity(cachedData.count / 20)
        var contactContainers: [[ContactEntity]] = []
        contactContainers.reserveCapacity(30)

        contactContainers = cachedData.reduce(contactContainers) { partialResult, entity in
            guard let leadingChar = entity.firstName.first else {
                return partialResult
            }
            guard let _ = partialResult.firstIndex(where: { contacts in
                contacts.first?.firstName.first == leadingChar}) else {
                return partialResult + [.init([entity])]
            }
            return partialResult
        }
    }
}
