//
//  MainScreenInteractor.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import RealmSwift

// MARK: - Interactor
class MainScreenInteractor: MainScreenInteractorProtocol {
    weak var interactorOutput: MainScreenInteractorOutput?
    
//    var firebaseTokenManager: FirebaseTokenManagerProtocol?
    var userDataManager: UserDataManagerProtocol?
    
    func getProfileDataSource() {
        let profileDataSource = userDataManager?.getUser()
        
        interactorOutput?.onGetProfileDataSourceOutput(datasource: profileDataSource)
    }
    
    /*func getAuditsDataSource() {
        
        let keyPathToSortBy = "createdAt"
        
        interactorOutput?.onGetAuditsDataSourceOutput(
            dataSource: RealmRepo<Audit>.getAll().sorted(
                byKeyPath: keyPathToSortBy,
                ascending: false
                ).map {
                    $0 as AuditCellDataSource & AuditDetailDataSource
            }
        )
    }
    
    func getAudits() {
        API.call(
            responseDataType: AuditsResponse.self,
            resource: .getAudits,
            onResponse: {
                [weak self] in
                
                guard let self = self else {
                    return
                }
                
                self.interactorOutput?.onGetAuditsResponse()
            }, onSuccess: {
                [weak self] response in
                
                guard let self = self else {
                    return
                }
                
                guard let audits = response.audits else {
                    return
                }
                
                RealmRepo<Audit>.add(itemList: audits) {
                    self.interactorOutput?.onGetAuditsSuccess()
                }
            }, onFailure: {
                [weak self] in
                
                guard let self = self else {
                    return
                }
                
                self.interactorOutput?.onGetAuditsFailure()
            }
        )
    }
    func reportAuditUsing(auditID: String) {
        API.call(
            responseDataType: ReportAuditResponse.self,
            resource: .reportAudit(id: auditID),
            onResponse: {
                [weak self] in
                
                guard let self = self else {
                    return
                }
                
                self.interactorOutput?.onReportAuditResponse()
            }, onSuccess: {
                [weak self] response in
                
                guard let self = self else {
                    return
                }
                
                guard
                    let error = response.errors?.first,
                    let status = error.status,
                    let statusCode = StatusCode(rawValue: status) else {
                        self.interactorOutput?.onReportAuditFailure(with: .defaultAlertMessage)
                        return
                }
                
                switch statusCode {
                case .accepted:
                    self.interactorOutput?.onReportAuditSuccess()
                case .alreadyReported:
                    self.interactorOutput?.onReportAuditFailure(with: .alreadyReported)
                }
            }, onFailure: {
                [weak self] in
                
                guard let self = self else {
                    return
                }
                
                self.interactorOutput?.onReportAuditFailure(with: .defaultAlertMessage)
            }
        )
    }
    */
    
    func performLogout() {
        guard
            let sessionID = UserDefaults.OAuth2URLData.string(forKey: .sessionID),
            let sessionState = UserDefaults.OAuth2URLData.string(forKey: .sessionState) else {
                self.interactorOutput?.onLogoutPerformed()
                
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
                
                self.interactorOutput?.onLogoutPerformed()
            }
        )
    }
    
    func cleanData() {
        OAuth2ClientHandler.shared.forgetTokens()
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
            
            interactorOutput?.onCleanedData()
        }
    }
    
    /*func clearFirebaseToken() {
        guard
            let user = userDataManager?.getUser(),
            let profileID = user.profile?.credentials.first?.profileID else {
                return
        }
        
        firebaseTokenManager?.clearFirebaseToken(using: profileID)
    }*/
}

/*
// MARK: - FirebaseTokenManagerOutputProtocol
extension MainScreenInteractor: FirebaseTokenManagerOutputProtocol {
    func onUpdateFirebaseTokenSuccess() {
        print("onUpdateFirebaseTokenSuccess")
    }
    
    func onUpdateFirebaseTokenFailure() {
        print("onUpdateFirebaseTokenFailure")
    }
    
    func onClearFirebaseTokenSuccess() {
        interactorOutput?.onClearedFirebaseToken()
    }
    
    func onClearFirebaseTokenFailure() {
        interactorOutput?.onClearedFirebaseToken()
    }
}
*/
