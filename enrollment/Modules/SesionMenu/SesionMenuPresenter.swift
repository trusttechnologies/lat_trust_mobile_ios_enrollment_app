//
//  SesionMenuPresenter.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

// MARK: - Presenter
class SesionMenuPresenter: SesionMenuPresenterProtocol {
    weak var view: SesionMenuViewProtocol?
    var interactor: SesionMenuInteractorProtocol?
    var router: SesionMenuRouterProtocol?
    
    func onLoginButtonPressed(from context: AnyObject) {
        interactor?.authorizeUser(from: context)
    }
}

extension SesionMenuPresenter: SesionMenuInteractorOutput {
    func onAuthorizeSuccess() {
//        view?.startActivityIndicator()
        interactor?.getUserProfile()
    }
    
    func onAuthorizeFailure(with errorMessage: String) {
        router?.presentAlertView(with: errorMessage)
    }
    
    func onGetUserProfileResponse() {
//        view?.stopActivityIndicator()
    }
    
    func onGetUserProfileSuccess() {
//        router?.goToWelcomeScreen()
    }
    
    func onGetUserProfileFailure(with errorMessage: String) {
        router?.presentAlertView(with: errorMessage)
    }
    
    func onUserDataSaved() {
//        interactor?.updateFirebaseToken()
    }
    
    func onMissingInfoFromRetrievedProfile() {
//        router?.goToUserDataRequestScreen()
    }
    
    
}
