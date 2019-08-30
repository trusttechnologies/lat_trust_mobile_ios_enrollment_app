//
//  SplashInteractor.swift
//  enrollment
//
//  Created by Kevin Torres on 8/29/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Foundation

class SplashInteractor: SplashInteractorProtocol {
    var interactorOutput: SplashInteractorOutputProtocol?
    
    var oauth2Manager: OAuth2ManagerProtocol?
    
    var userDataManager: UserDataManagerProtocol?
    
    func getUser() {
        if userDataManager?.getUser() != nil {
            interactorOutput?.onGetUserSuccess() //Check Access token
        } else {
            interactorOutput?.onGetUserFailure()
        }
    }
    
    func clearData() {
        userDataManager?.deleteAll(completion: nil)
        oauth2Manager?.clearTokens()
        
        interactorOutput?.onDataCleared()
    }

    func checkAccessToken() {
        if oauth2Manager?.getAccessToken() != nil {
            interactorOutput?.onCheckAccessTokenSuccess() //Go to main screen
        } else {
          interactorOutput?.onCheckAccessTokenFailure() //Silentauth
        }
    }
    
    func checkRefreshToken() {
        if oauth2Manager?.getRefreshToken() != nil {
            interactorOutput?.onRefreshTokenSuccess()
        } else {
            interactorOutput?.onRefreshTokenFailure()
        }
    }
    
    func authenticate(context: AnyObject) {
        oauth2Manager?.silentAuthorize(from: context)
    }
}

extension SplashInteractor: OAuth2ManagerOutputProtocol {
    func onAuthorizeSuccess() {
        print("onAuthorizeSuccess")
    }
    
    func onAuthorizeFailure(with errorMessage: String) {
        print("onAuthorizeFailure")
    }
    
    func onSilentAuthorizeSuccess() {
        interactorOutput?.onAuthenticateSuccess()
    }
    
    func onSilentAuthorizeFailure() {
        interactorOutput?.onAuthenticateFailure()
    }
}
