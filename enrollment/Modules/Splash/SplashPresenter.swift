//
//  SplashPresenter.swift
//  enrollment
//
//  Created by Kevin Torres on 8/29/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Foundation

class SplashPresenter: SplashPresenterProtocol {
    var view: SplashViewProtocol?
    
    var router: SplashRouterProtocol?
    
    var interactor: SplashInteractorProtocol?
    
    func onViewDidAppear() {
        interactor?.getUser()
    }
}

extension SplashPresenter: SplashInteractorOutputProtocol {
    func onGetUserSuccess() {
        interactor?.checkAccessToken()
    }
    
    func onGetUserFailure() {
        router?.goToSesionMenuScreen()
    }
    
    func onCheckAccessTokenSuccess() {
        router?.goToMainScreen()
    }
    
    func onCheckAccessTokenFailure() {
        interactor?.checkRefreshToken()
    }
    
    func onRefreshTokenSuccess() {
        if let context = router?.viewController {
            interactor?.authenticate(context: context)
        }
    }
    
    func onRefreshTokenFailure() {
        interactor?.clearData()
    }
    
    func onAuthenticateSuccess() {
        router?.goToMainScreen()
    }
    
    func onAuthenticateFailure() {
        router?.goToSesionMenuScreen()
    }
    
    func onDataCleared() {
        router?.goToSesionMenuScreen()
    }
}
