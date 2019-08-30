//
//  MainScreenInteractor.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import RealmSwift
import TrustDeviceInfo

// MARK: - Interactor
class MainScreenInteractor: MainScreenInteractorProtocol {
    weak var interactorOutput: MainScreenInteractorOutput?
    
    var userDataManager: UserDataManagerProtocol?
    var trustIdDataManager: TrustIdDataManagerProtocol?
    
    func performLogout() {
        guard
            let sessionID = UserDefaults.OAuth2URLData.string(forKey: .sessionID),
            let sessionState = UserDefaults.OAuth2URLData.string(forKey: .sessionState) else {
                self.interactorOutput?.onLogoutPerformed() //Call onLogoutPerformed
                
                return
        }
        
        let parameters = LogoutParameters(
            sessionID: sessionID,
            sessionState: sessionState
        )
        
        API.callAsJSON(
            resource: .logout(parameters: parameters),
            onResponse: {
                [weak self] in
                
                guard let self = self else {
                    return
                }
                
                self.interactorOutput?.onLogoutPerformed() //Call onLogoutPerformed in MainScreenPresenter
            }
        )
    }

    func getProfileDataSource() {
        let profileDataSource = userDataManager?.getUser()
        
        interactorOutput?.onGetProfileDataSourceOutput(datasource: profileDataSource)
    }
    
    func getTrustIdDataSource() {
        let trustIdDataSource = trustIdDataManager?.getTrustID()
        
        interactorOutput?.onGetTrustIdDataSourceOutPut(trustId: trustIdDataSource)
    }
    
    func callCleanData() {
        self.cleanData()
    }
    
    func cleanData() {
        OAuth2ClientHandler.shared.forgetTokens()
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
            
            interactorOutput?.onCleanedData()
        }
    }
}

extension MainScreenInteractor {
    func onClearData() {
        interactorOutput?.onClearedData()
    }
}
