//
//  MainScreenInteractor.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import RealmSwift
import TrustDeviceInfo
import Audit

// MARK: - Interactor
class MainScreenInteractor: MainScreenInteractorProtocol {
    
    weak var interactorOutput: MainScreenInteractorOutput?
    
    var userDataManager: UserDataManagerProtocol?
    var auditDataManager: AuditDataManagerProtocol?
    
    var permissionsManager: PermissionsManagerProtocol?
    
    let generatedTrustId = Identify.shared.getTrustID()

    func openSettings() {
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func checkBothPermissions() {
        permissionsManager?.checkBothPermissions()
    }
    
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
        interactorOutput?.onGetTrustIdDataSourceOutPut(trustId: generatedTrustId)
    }
    
    func cleanData() {
        OAuth2ClientHandler.shared.forgetTokens()
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
            
            interactorOutput?.onCleanedData()
        }
    }
    
    // MARK: - Login Audit
    func loginAudit() {
        auditDataManager?.createLoginAudit()
    }
}

extension MainScreenInteractor {
    func onClearData() {
        interactorOutput?.onClearedData()
    }
}

// MARK: - PermissionsManagerOutputProtocol
extension MainScreenInteractor: PermissionsManagerOutputProtocol {
    func permissionsSuccess() {
        print("xd")
    }
    
    func permissionsFail() {
        interactorOutput?.showMessage()
    }
}
