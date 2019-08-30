//
//  TrustIdDataManager.swift
//  enrollment
//
//  Created by Kevin Torres on 8/27/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Foundation
import TrustDeviceInfo

// MARK: - TrustIdDataManagerProtocol
protocol TrustIdDataManagerProtocol: AnyObject {
    func getTrustID() -> String?
    func setKeychainData(serviceName: String?, accessGroup: String?)
    func enableTrustID()
    func showTrustID()
}

// MARK: - OAuth2ManagerOutputProtocol
protocol TrustIdDataManagerOutputProtocol: AnyObject {
    func setKeychainDataSuccess()
}

// MARK: - getTrustIdDataManager
class TrustIdDataManager: TrustDeviceInfoDelegate, TrustIdDataManagerProtocol {
    var userTrustID: String?
    
    init() {
        Identify.shared.trustDeviceInfoDelegate = self
    }
    
    func setKeychainData(serviceName: String?, accessGroup: String?) {
        Identify.shared.set(serviceName: serviceName ?? "", accessGroup: accessGroup ?? "")
    }
    
    func enableTrustID() {
        Identify.shared.enable()
    }
    
    
    func getTrustID() -> String? {
        return userTrustID
    }
    
    func showTrustID() {
        print("SAVED TRUST ID: \(userTrustID)")
    }
    
    func onClientCredentialsSaved(savedClientCredentials: ClientCredentials) {
        //TODO
    }
    
    func onTrustIDSaved(savedTrustID: String) {
        self.userTrustID = savedTrustID
        print("Saved trust ID: \(savedTrustID)")
    }
    
    func onRegisterFirebaseTokenSuccess(responseData: RegisterFirebaseTokenResponse) {
        //TODO
    }
    
    func onSendDeviceInfoResponse(status: ResponseStatus) {
        //TODO
    }
}

