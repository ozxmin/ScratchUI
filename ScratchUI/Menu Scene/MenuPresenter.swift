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

    private(set) var state: ViewState

    class ViewState {
        var title: String
        var options: [SceneOptions]
        init(title: String, options: [SceneOptions]) {
            self.title = title
            self.options = options
        }
    }

    init() {
        let title = "Menu"
        let options = SceneOptions.allCases
        state = ViewState(title: title, options: options)
    }
}

// MARK: - Conformance
extension MenuPresenter {
    func onViewDidLoad() {
        view?.setState(state: state)
        view?.bareLayout()
    }

    func onDidTapRow(at index: IndexPath) {
        let chosen = state.options[index.row]
        router.navigate(to: chosen)

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
