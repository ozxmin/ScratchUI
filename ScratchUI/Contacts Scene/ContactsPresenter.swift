//
//  ContactsPresenter.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 04/11/24.
//

import Foundation

protocol ContactsPresenterProtocol {
    func onViewDidLoad()
    func onSwitchLayout()
    func onDidSelectItem(at indexPath: IndexPath)
}

class ContactsPresenter: ContactsPresenterProtocol {
    let title = "Contacts"
    var layout: LayoutStyle = .list { didSet { view?.layout(with: layout) } }
    var loading: Bool = false { didSet { view?.isLoading(shown: loading) } }

    var view: ContactsViewProtocol?
    var interactor: ContactsInteractor!

    init(view: ContactsViewProtocol) {
        interactor = ContactsInteractor()
        self.view = view
    }
}

// Conformance
extension ContactsPresenter {
    func onViewDidLoad() {
        bareSetUp()
        // TODO: deal with async requests
        // a better way to handle loading screens
        loading = true
        // concurrent async
        guard let entities = interactor.getContacts() else {
            //show error
            return
        }
        setTableData(contacts: entities)
//        view?.setSections(sections: parseToSections(from: contacts))
//        view?.setContacts(contacts: contacts)
        loading = false
    }

    func onSwitchLayout() {
        layout.toggle()
    }

    func onDidSelectItem(at indexPath: IndexPath) {
        //router stuff
        // create detailed display
        //view?.navigate(with: ContactDisplay)
    }
}

extension ContactsPresenter {
    private func bareSetUp() {
        view?.configureInitialView()
        view?.layout(with: layout)
        view?.setTitle(title)
    }

    private func setTableData(contacts: [ContactEntity]) {
        //data fetching
        //parseToSections
        //Sort contacts
        //order contacts
        //set sections array
        //set ContactDisplay basic
        let dict = Dictionary(grouping: contacts, by: { $0.lastName.first?.uppercased() ?? "#"})
        let sections: [String] = dict.keys.sorted().map { String($0) }
        view?.setSections(sections: sections)
        
        let sortedRows: [[ContactEntity]] = dict.values.sorted { section1, section2 in
            section1.first?.lastName.lowercased() ?? "" < section2.first?.lastName.lowercased() ?? ""
        }.map { contacts in
            contacts.sorted { $0.lastName.lowercased() < $1.lastName.lowercased() }
        }
        let basicInfo: [[ContactDisplay<Info.Basic>]] = sortedRows.map { sections in
            sections.map { ContactDisplay($0) }
        }
        view?.setContacts(contacts: basicInfo)
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
