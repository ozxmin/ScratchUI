//
//  ContactsCollectionViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 16/10/24.
//

import UIKit

class ContactsCollectionViewController: UICollectionViewController {
    private let source = ContactsCollectionDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        configureNavigationBar()
    }
}

// MARK: - Configure Bars

extension ContactsCollectionViewController {
    private func configureNavigationBar() {
        title = "Contacts"
        navigationController?.isNavigationBarHidden = false

        let listButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(switchToListView))
        navigationItem.rightBarButtonItem = listButton
    }

    @objc private func switchToListView() {
        let tableVC = ContactsTableViewController(style: .plain)
        navigationController?.setViewControllers([tableVC], animated: true)
    }
}

// MARK: - Collection Delegate

extension ContactsCollectionViewController {
    private func configureDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = source
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: ContactCollectionViewCell.id)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        source.numberOfSections(in: collectionView)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        source.numberOfSections(in: collectionView)
    }


    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contactDetailVC = ContactDetailsViewController()
        let contact: ContactDisplay<Info.Detailed> = source.getDetailsDisplay(for: indexPath)
            contactDetailVC.detail = contact
            show(contactDetailVC, sender: nil)

    }
}
