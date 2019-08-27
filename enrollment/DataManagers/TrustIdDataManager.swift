//
//  TrustIdDataManager.swift
//  enrollment
//
//  Created by Kevin Torres on 8/27/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Foundation
import TrustDeviceInfo


protocol TrustIdDataManagerProtocol {
    func getTrustID() -> String?
}

// MARK: - getTrustIdDataManager
class TrustIdDataManager: TrustDeviceInfoDelegate, TrustIdDataManagerProtocol {
    var userTrustID: String?
    
    func getTrustID() -> String? {
        return userTrustID
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

