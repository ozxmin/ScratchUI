//
//  ContactsInteractor.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/11/24.
//

import Foundation

protocol ContactsInteractorProtocol { }


class ContactsInteractor {
    let dataManager: ContactsDataManagerProtocol
    init() {
        dataManager = ContactsDataManager()
    }

}

extension ContactsInteractor {

    func getContacts() -> [ContactEntity]? {
        dataManager.getContactEntities()
    }
}
