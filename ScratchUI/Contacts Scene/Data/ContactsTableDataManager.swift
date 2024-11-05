//
//  ContactsTableDataSource.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 02/09/24.
//

import UIKit

// MARK: - Contacts Table DataSource
final class ContactsTableDataManager: ContactsDataManagerProtocol {
    var dataSource: ContactsDataSource
    init() {
        dataSource = ContactsDataSource()
    }
}

// MARK: - Contacts Collection Data Source

final class ContactsCollectionDataManager: NSObject {
    private let dataManager: ContactsDataSource

    override init() {
        dataManager = ContactsDataSource()
        super.init()
    }
}

// MARK: - Extra
extension ContactsCollectionDataManager {
    func sections() -> [String] {
        dataManager.getSortedSections()
    }

    func getDetailsDisplay<T>(for indexPath: IndexPath) -> ContactDisplay<T> {
        let contact = dataManager.getContact(at: indexPath)
        let details: ContactDisplay<T> = .init(contact)
        return details
    }
}

extension ContactsCollectionDataManager: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataManager.getSortedSections().count
    }

    func indexTitles(for collectionView: UICollectionView) -> [String]? {
        dataManager.getSortedSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionIndex = dataManager.getSortedSections()[section]
        return dataManager.sectionsAndContactsSorted()[sectionIndex]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item: ContactCollectionViewCell = collectionView.dequeueItem(for: indexPath)
        let contact = dataManager.getContact(at: indexPath)

        let details: ContactDisplay<Info.Detailed> = .init(contact)
        item.configure(with: details)

        return item
    }
}

