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
}

class ContactsPresenter {
    let title = "Contacts"
    var layout: LayoutStyle = .list {
        didSet { view?.layout(with: layout) }
    }

    var view: ContactsViewProtocol?
    var interactor: ContactsInteractorProtocol?
}

// Conformance
extension ContactsPresenter {
    func onViewDidLoad() {
        bareSetUp()
        dataFetching()
    }

    func switchLayout() {
        layout.toggle()
    }

    func didSelectItem(at indexPath: IndexPath) {
        //router stuff
        // create detailed display
//        view?.navigate(with: <#T##ContactDisplay<Info.Detailed>#>)
    }

}

extension ContactsPresenter {
    private func bareSetUp() {
        view?.configureInitialView()
        view?.layout(with: layout)
        view?.setTitle(title)
    }

    func dataFetching() {
        // TODO: deal with async requests
        // a better way to handle loading screens
        view?.isLoading(shown: true)
        // concurrent async
        let contacts = getContacts()
        view?.setContacts(contacts: contacts!)
        let sections = getSections()
        view?.setSections(sections: sections)
        view?.isLoading(shown: false)
    }

    private func getContacts() -> [[ContactDisplay<Info.Basic>]]? {
//        interactor?.contacts //interactor objects
        //create displayInfo
        return nil
    }

    private func getSections() -> [String]{
        [""]
    }
}

enum LayoutStyle {
    case grid, list
    mutating func toggle() {
        switch self {
            case .grid: self = .list
            case .list: self = .grid
        }
    }
}
