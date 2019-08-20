//
//  TrustAudit.swift
//  TrustAudit
//
//  Created by Kevin Torres on 8/14/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Alamofire
import CoreTelephony

// MARK: - AuditDelegate
public protocol AuditDelegate: AnyObject {
    func onCreateAuditResponse()
    func onCreateAuditSuccess(responseData: CreateAuditResponse)
    func onCreateAuditFailure()
}

// MARK: - TrustAudit
public class TrustAudit {
    // MARK: - APIManager
    private lazy var apiManager: APIManagerProtocol = {
        let apiManager = APIManager()
        apiManager.managerOutput = self
        return apiManager
    }()
    
    // MARK: - Delegates
    public weak var auditDelegate: AuditDelegate?
    
    public var sendDeviceInfoCompletionHandler: ((ResponseStatusT) -> Void)?
    
    // MARK: - Private Init
    private init() {}
    
    static var trustID: String {
        return UserDefaults.standard.string(forKey: "trustID") ?? "ERROR"
    }
    
    private static var trustAudit: TrustAudit = {
        return TrustAudit()
    }()
    
    // MARK: - Shared instance
    public static var shared: TrustAudit {
        return trustAudit
    }
}

// MARK: - Public Methods
extension TrustAudit {
    public func setTrustID(trustID: String){
        UserDefaults.standard.set(trustID, forKey: "trustID")
    }
    
    public func createAudit(with parameters: CreateAuditParameters, tokenType: String, accessToken: String) {
        
        let credential = "\(tokenType) \(accessToken)"
        
        apiManager.createAudit(with: parameters, credential: credential)
    }
}

// MARK: - APIManagerOutputProtocol
extension TrustAudit: APIManagerOutputProtocol {
    func onCreateAuditResponse() {
        auditDelegate?.onCreateAuditResponse()
    }
    
    func onCreateAuditSuccess(responseData: CreateAuditResponse) {
        auditDelegate?.onCreateAuditSuccess(responseData: responseData)
    }
    
    func onCreateAuditFailure() {
        auditDelegate?.onCreateAuditFailure()
    }
}
