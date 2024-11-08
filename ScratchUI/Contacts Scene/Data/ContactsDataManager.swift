//
//  ContactsDataSource.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 18/10/24.
//

import Foundation

// TODO: - Don't use ui specific terms in the datasource

protocol ContactsDataManagerProtocol {
    var dataSource: ContactsDataSource { get }

    func getDetailsDisplay<T>(for indexPath: IndexPath) -> ContactDisplay<T>
    func sections() -> [String]
    func numberOfItems(in section: Int) -> Int
}

extension ContactsDataManagerProtocol {
    func section(at index: Int) -> String {
        sections()[index]
    }

    func sections() -> [String] {
        dataSource.getSortedSections()
    }

    func getDetailsDisplay<T>(for indexPath: IndexPath) -> ContactDisplay<T> {
        let contact = dataSource.getContact(at: indexPath)
        let details: ContactDisplay<T> = .init(contact)
        return details
    }

    func numberOfItems(in section: Int) -> Int {
        let sectionIndex = dataSource.getSortedSections()[section]
        let sortedContacts = dataSource.sectionsAndContactsSorted()
        return dataSource.sectionsAndContactsSorted()[sectionIndex]?.count ?? 0
    }
}
