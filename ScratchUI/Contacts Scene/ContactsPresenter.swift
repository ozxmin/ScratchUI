//
//  ContactsPresenter.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/11/24.
//

import Foundation

protocol ContactsPresenterProtocol {
    func onViewDidLoad()

    func switchLayout()
    func didSelectItem(at indexPath: IndexPath)
    func infoForItem(at indexPath: IndexPath)


}

class ContactsPresenter {

}
