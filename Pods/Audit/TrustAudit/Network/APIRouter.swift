//
//  APIRouter.swift
//  TrustAudit
//
//  Created by Kevin Torres on 8/14/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Alamofire

// MARK: - APIRouter
enum APIRouter: URLRequestConvertible {
    case createAudit(parameters: Parameterizable, authorizationHeader: String) //Receive authorization by parameters
    
    var path: String {
        switch self {
        case .createAudit:
            return "/audit\(API.apiVersion)/audit"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createAudit:
            return .post
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .createAudit(let parameters, _):
            return parameters.asParameters
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var baseURLAsString: String = .empty
        
        switch self {
        case .createAudit:
            baseURLAsString = API.baseURL
        }
        
        guard let url = URL(string: baseURLAsString) else {
            return URLRequest(url: URL(string: .empty)!)
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        defer {
            print("urlRequest: \(urlRequest)")
            print("urlRequest.allHTTPHeaderFields: \(String(describing: urlRequest.allHTTPHeaderFields))")
            print("Parameters: \(parameters)")
        }
        
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .createAudit(_, let authorizationHeader):
            urlRequest.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .createAudit:
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
