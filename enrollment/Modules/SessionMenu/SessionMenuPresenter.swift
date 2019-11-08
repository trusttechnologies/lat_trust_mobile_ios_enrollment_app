//
//  SessionMenuPresenter.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import CoreLocation

// MARK: - Presenter
class SessionMenuPresenter: SessionMenuPresenterProtocol {
    weak var view: SessionMenuViewProtocol?
    var interactor: SessionMenuInteractorProtocol?
    var router: SessionMenuRouterProtocol?
    
    func onLoginButtonPressed(from context: AnyObject) {
        view?.startActivityIndicator()
        interactor?.authorizeUser(from: context)
    }
}

extension SessionMenuPresenter: SessionMenuInteractorOutput {
    func onAuthorizeSuccess() {
        interactor?.getUserProfile()
    }
    
    func onAuthorizeFailure(with errorMessage: String) {
        router?.presentAlertView(with: errorMessage)
        view?.stopActivityIndicator()
    }
    
    func onGetUserProfileResponse() {
        view?.stopActivityIndicator()
    }
    
    func onGetUserProfileSuccess() {
        router?.goToMainScreen()
    }
    
    func onGetUserProfileFailure(with errorMessage: String) {
        router?.presentAlertView(with: errorMessage)
    }
    
    func onUserDataSaved() {
        //TODO
    }
    
    func onMissingInfoFromRetrievedProfile() {
        //TODO
    }
}
