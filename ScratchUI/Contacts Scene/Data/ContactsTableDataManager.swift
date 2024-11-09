//
//  ContactsTableDataSource.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 02/09/24.
//

import UIKit

// MARK: - Contacts Collection Data Source

final class ContactsCollectionDataManager: NSObject {
    private let contactsDataSource: ContactsDataSource

    override init() {
        contactsDataSource = ContactsDataSource()
        super.init()
    }
}

// MARK: - Extra
extension ContactsCollectionDataManager {
    func sections() -> [String] {
        contactsDataSource.getSortedSections()
    }

    func getDetailsDisplay<T>(for indexPath: IndexPath) -> ContactDisplay<T> {
        let contact = contactsDataSource.getContact(at: indexPath)
        let details: ContactDisplay<T> = .init(contact)
        return details
    }
}

extension ContactsCollectionDataManager: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        contactsDataSource.getSortedSections().count
    }

    func indexTitles(for collectionView: UICollectionView) -> [String]? {
        contactsDataSource.getSortedSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionIndex = contactsDataSource.getSortedSections()[section]
        return contactsDataSource.sectionsAndContactsSorted()[sectionIndex]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item: ContactCollectionViewCell = collectionView.dequeueItem(for: indexPath)
        let contact = contactsDataSource.getContact(at: indexPath)

        let details: ContactDisplay<Info.Detailed> = .init(contact)
        item.configure(with: details)

        return item
    }
}

