//
//  SplashInteractor.swift
//  enrollment
//
//  Created by Kevin Torres on 8/25/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import RealmSwift

class SplashInteractor: SplashInteractorProtocol {
    weak var interactorOutput: SplashInteractorOutput?
    
    var oauth2Manager: OAuth2ManagerProtocol?
    var userDataManager: UserDataManagerProtocol?
    
    func checkIfUserHasLoggedIn() {
        guard userDataManager?.getUser() != nil else {
            interactorOutput?.onUserHasLoggedInFailure()
            return
        }
        
        guard oauth2Manager?.getAccessToken != nil else {
            guard oauth2Manager?.getRefreshToken != nil else {
                interactorOutput?.onUserHasLoggedInFailure()
                return
            }
            
            interactorOutput?.onUserHasLoggedInSuccess()
            
            return
        }
        
        interactorOutput?.onUserHasLoggedInSuccess()
    }
    
    func authorize(from context: AnyObject) {
        oauth2Manager?.silentAuthorize(from: context)
    }
    
    func cleanData() {
        oauth2Manager?.clearTokens()
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
            
            interactorOutput?.onDataCleaned()
        }
    }
}

// MARK: - OAuth2ManagerOutputProtocol
extension SplashInteractor: OAuth2ManagerOutputProtocol {
    func onAuthorizeSuccess() {
        print("onAuthorizeSuccess")
    }
    
    func onAuthorizeFailure(with errorMessage: String) {
        print("onAuthorizeFailure")
    }
    
    func onSilentAuthorizeSuccess() {
        interactorOutput?.onAuthorizeSuccess()
    }
    
    func onSilentAuthorizeFailure() {
        interactorOutput?.onAuthorizeFailure()
    }
}
