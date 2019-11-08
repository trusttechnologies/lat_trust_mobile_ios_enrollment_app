//
//  API.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

enum StatusCode: Int {
    case accepted = 202
    case alreadyReported = 208
}

enum API {
    static let baseURL = "https://api.autentia.id"
    static let clientId = "@!3011.6F0A.B190.8457!0001!294E.B0CD!0008!40E4.A0F9.9E5E.9E81"
}

extension API {
    static func call<T: Mappable>(responseDataType: T.Type, resource: APIRouter, onResponse: CompletionHandler = nil, onSuccess: SuccessHandler<T> = nil, onFailure: CompletionHandler = nil) {
        
        let retrier = OAuth2RetryHandler(oauth2: OAuth2ClientHandler.shared)
        SessionManager.default.adapter = retrier
        SessionManager.default.retrier = retrier
        
        SessionManager.default.request(resource).responseObject {
            (response: DataResponse<T>) in
            
            print("API.call() Response: \(response)")
            
            onResponse?()
            
            switch (response.result) {
            case .success(let response):
                onSuccess?(response)
            case .failure(_):
                onFailure?()
            }
        }
    }
    
    static func callAsJSON(resource: APIRouter, onResponse: CompletionHandler = nil, onSuccess: CompletionHandler = nil, onFailure: CompletionHandler = nil) {
        
        let retrier = OAuth2RetryHandler(oauth2: OAuth2ClientHandler.shared)
        SessionManager.default.adapter = retrier
        SessionManager.default.retrier = retrier
        
        SessionManager.default.request(resource).responseJSON {
            (response: DataResponse<Any>) in
            
            print("API.callAsJSON() Response as JSON: \(response)")
            
            if let onResponse = onResponse {
                onResponse()
            }
            
            switch (response.result) {
            case .success(_):
                guard let onSuccess = onSuccess else {
                    return
                }
                
                onSuccess()
            case .failure(_):
                guard let onFailure = onFailure else {
                    return
                }
                
                onFailure()
            }
        }
    }
}
