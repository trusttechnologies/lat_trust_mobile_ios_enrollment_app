//
//  WelcomeScreenPresenter.swift
//  enrollment
//
//  Created by Kevin Torres on 8/24/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

// MARK: - Presenter
class WelcomeScreenPresenter: WelcomeScreenPresenterProtocol {
    weak var view: WelcomeScreenViewProtocol?
    var interactor: WelcomeScreenInteractorProtocol?
    var router: WelcomeScreenRouterProtocol?
    
    func onViewDidLoad() {
        interactor?.getWelcomeScreenDataSource()
    }
    
    func onContinueButtonPressed() {
        router?.dismiss()
    }
}

// MARK: - WelcomeScreenInteractorOutput
extension WelcomeScreenPresenter: WelcomeScreenInteractorOutput {
    func onGetWelcomeScreenDataSourceOutput(dataSource: WelcomeScreenDataSource) {
        view?.set(dataSource: dataSource)
    }
}
