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
    var router: MenuRouter!

    //private(set) var state: ViewState

    class ViewState {
        var title: String
        var options: [Scene]
        init(title: String, options: [Scene]) {
            self.title = title
            self.options = options
        }
    }
}

// MARK: - Conformance
extension MenuPresenter {
    func onViewDidLoad() {
        view?.bareLayout()
        
    }

    func onDidTapRow(at index: IndexPath) {
        router.navigate(to: .contacts)
        
    }
    func setTableData() {
//        view?.setTable(data: scenes)
    }
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
