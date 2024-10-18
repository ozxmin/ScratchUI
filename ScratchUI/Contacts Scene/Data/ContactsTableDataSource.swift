//
//  ContactsTableDataSource.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 02/09/24.
//

import UIKit

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
        dataManager.getSortedSections()
    }

    func getDetailsDisplay<T>(for indexPath: IndexPath) -> ContactDisplay<T> {
        let contact = dataManager.getElement(at: indexPath)
        let details: ContactDisplay<T> = .init(contact)
        return details
    }
}

// MARK: - UITableViewDataSource

extension ContactsTableDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataManager.getSortedContacts().count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        dataManager.getSortedSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionIndex = dataManager.getSortedSections()[section]
        return dataManager.getSortedContacts()[sectionIndex]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: ContactTableCell = tableView.dequeueItem(for: indexPath)
        let contact = dataManager.getElement(at: indexPath)
        cell.fillIn(with: contact)

        return cell
    }
}


final class ContactsCollectionDataSource: NSObject {
    private let dataManager: ContactsDataManager

    override init() {
        dataManager = ContactsDataManager()
        super.init()
    }
}

extension ContactsCollectionDataSource {
    func sections() -> [String] {
        dataManager.getSortedSections()
    }

    func getDetailsDisplay<T>(for indexPath: IndexPath) -> ContactDisplay<T> {
        let contact = dataManager.getElement(at: indexPath)
        let details: ContactDisplay<T> = .init(contact)
        return details
    }
}


extension ContactsCollectionDataSource: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataManager.getSortedSections().count
    }

    func indexTitles(for collectionView: UICollectionView) -> [String]? {
        dataManager.getSortedSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionIndex = dataManager.getSortedSections()[section]
        return dataManager.getSortedContacts()[sectionIndex]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item: ContactCollectionViewCell = collectionView.dequeueItem(for: indexPath)
        let contact = dataManager.getElement(at: indexPath)

        let details: ContactDisplay<Info.Detailed> = .init(contact)
        item.configure(with: details)

        return item
    }
}

