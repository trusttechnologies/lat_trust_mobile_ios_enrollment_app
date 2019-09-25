//
//  SessionMenuInteractor.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

// MARK: - Interactor
class SessionMenuInteractor: SessionMenuInteractorProtocol {
    
    weak var interactorOutput: SessionMenuInteractorOutput?
    
    var oauth2Manager: OAuth2ManagerProtocol?
    var userDataManager: UserDataManagerProtocol?
    
    func authorizeUser(from context: AnyObject) {
        oauth2Manager?.authorizeUser(from: context)
    }
    
//    func getUser() {
//        if userDataManager?.getUser() != nil {
//            interactorOutput?.onGetUserSuccess() //Check Access token
//        } else {
//            interactorOutput?.onGetUserFailure()
//        }
//    }
    
    
    func getUserProfile() {
        let parameters = ProfileParameters(accessToken: OAuth2ClientHandler.shared.accessToken)
        
        API.call(
            responseDataType: User.self,
            resource: .getProfile(parameters: parameters),
            onResponse: {
                [weak self] in
                
                guard let self = self else {
                    return
                }
                
                self.interactorOutput?.onGetUserProfileResponse()
            }, onSuccess: {
                [weak self] userData in
                
                guard let self = self else {
                    return
                }
                
                self.userDataManager?.add(user: userData) {
                    self.interactorOutput?.onUserDataSaved()
                    
                    guard !userData.checkIfUserHasMissingInfo() else {
                        self.interactorOutput?.onMissingInfoFromRetrievedProfile()
                        
                        return
                    }
                    
                    self.interactorOutput?.onGetUserProfileSuccess()
                }
            }, onFailure: {
                [weak self] in
                
                guard let self = self else {
                    return
                }
                
                self.interactorOutput?.onGetUserProfileFailure(with: .defaultAlertMessage)
            }
        )
    }
}

// MARK: - OAuth2ManagerOutputProtocol
extension SessionMenuInteractor: OAuth2ManagerOutputProtocol {
    func onSilentAuthorizeSuccess() {
        print("onSilentAuthorizeSuccess")
    }
    
    func onSilentAuthorizeFailure() {
        print("onSilentAuthorizeFailure")
    }
    
    func onAuthorizeSuccess() {
        interactorOutput?.onAuthorizeSuccess()
    }
    
    func onAuthorizeFailure(with errorMessage: String) {
        interactorOutput?.onAuthorizeFailure(with: errorMessage)
    }
}
