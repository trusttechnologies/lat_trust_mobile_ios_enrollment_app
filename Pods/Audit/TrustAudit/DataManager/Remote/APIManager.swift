//
//  APIManager.swift
//  TrustAudit
//
//  Created by Kevin Torres on 8/14/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Alamofire

// MARK: - APIManagerProtocol
protocol APIManagerProtocol: AnyObject {
    var managerOutput: APIManagerOutputProtocol? {get set}
    
    func createAudit(with parameters: CreateAuditParameters, credential: String)
}

// MARK: - APIManagerOutputProtocol
protocol APIManagerOutputProtocol: AnyObject {
    func onCreateAuditResponse()
    func onCreateAuditSuccess(responseData: CreateAuditResponse)
    func onCreateAuditFailure()
}

// MARK: - APIManager
class APIManager: APIManagerProtocol {
    weak var managerOutput: APIManagerOutputProtocol?
    
    func createAudit(with parameters: CreateAuditParameters, credential: String ) {
        API.call(
            responseDataType: CreateAuditResponse.self,
            resource: .createAudit(parameters: parameters, authorizationHeader: credential),
            onResponse: {
                [weak self] in
                guard let self = self else {return}
                self.managerOutput?.onCreateAuditResponse()
            }, onSuccess: {
                [weak self] responseData in
                guard let self = self else {return}
                self.managerOutput?.onCreateAuditSuccess(responseData: responseData)
            }, onFailure: {
                [weak self] in
                guard let self = self else {return}
                self.managerOutput?.onCreateAuditFailure()
            }
        )
    }
}
