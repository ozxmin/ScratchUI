//
//  MenuPresenter.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 20/12/24.
//

import Foundation

protocol MenuPresenterInterface {
    func onViewDidLoad()
    func onDidTapItem(at index: IndexPath)
}

class MenuPresenter: MenuPresenterInterface {
    var view: MenuViewInterface!
    var interactor: MenuInteractorInterface!
    var route: ((MenuFlows) -> ())?

    private(set) var state: ViewState

    class ViewState {
        var title: String
        var options: [MenuFlows]
        init(title: String, options: [MenuFlows]) {
            self.title = title
            self.options = options
        }
    }

    init() {
        let title = "Menu"
        state = ViewState(title: title, options: MenuFlows.allCases)
    }
}

// MARK: - Conformance
extension MenuPresenter {
    func onViewDidLoad() {
        view?.setState(state: state)
        view?.bareLayout()
    }

    func onDidTapItem(at index: IndexPath) {
        let chosen = state.options[index.row]
        route?(chosen)
    }
}


protocol MenuInteractorInterface {
    func processData()
}
final class MenuInteractor: MenuInteractorInterface {
    let prop: String = "prop"
    var dm = MenuDataManager()
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
