//
//  MenuPresenter.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 20/12/24.
//

import Foundation

protocol MenuPresenterInterface {
    func onViewDidLoad()
    func onDidTapRow(at index: IndexPath)
}

class MenuPresenter: MenuPresenterInterface {
    var view: MenuViewProtocol!
    var interactor: MenuInteractorProtocol!
    var router: RouterProtocol!

    let title = "Menu"
}

// MARK: - Conformance
extension MenuPresenter {
    func onViewDidLoad() {
        view?.bareLayout()
        view?.setTitle(title)
    }

    func onDidTapRow(at index: IndexPath) { }
    func setTableData() { }
}

protocol MenuInteractorProtocol {
    func processData()
}
final class MenuInteractor: MenuInteractorProtocol {
    let prop: String = "prop"
    var dm: MenuDataManagerProtocol!
}

// MARK: - Menu Interactor Conformance
extension MenuInteractor {
    func processData() {

    }
    func doSomething() -> String {
        "Hello World"
    }
}


protocol MenuDataManagerProtocol { }
class MenuDataManager: MenuDataManagerProtocol { }

protocol RouterProtocol { }
class Router: RouterProtocol { }
