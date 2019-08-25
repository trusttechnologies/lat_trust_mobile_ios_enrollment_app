//
//  APIRouter.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    case getProfile(parameters: Parameterizable)
    case updateProfile(id: String, parameters: Parameterizable)
    case getAudits
    case getAudit(id: String)
    case reportAudit(id: String)
    case logout(parameters: Parameterizable)
    
    var path: String {
        switch self {
        case .getProfile:
            return "/oxauth/restv1/userinfo"
        case .updateProfile(let id, _):
            return "/profile/v1/\(id)"
        case .getAudits:
            return "/audit/v1"
        case .getAudit(let id):
            return "/audit/v1/\(id)"
        case .reportAudit(let id):
            return "/audit/v1/\(id)/report"
        case .logout:
            return "/oxauth/restv1/end_session"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile, .getAudits, .getAudit, .reportAudit, .logout:
            return .get
        case .updateProfile:
            return .patch
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getAudits, .getAudit, .reportAudit:
            return [:]
        case .getProfile(let parameters):
            return parameters.asParameters
        case .updateProfile(_, let parameters):
            return parameters.asParameters
        case .logout(let parameters):
            return parameters.asParameters
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        defer {
            print("Parameters: \(parameters)")
        }
        
        var baseURLAsString: String?
        
        switch self {
        default:
            baseURLAsString = API.baseURL
        }
        
        guard let url = URL(string: baseURLAsString!) else {
            return URLRequest(url: URL(string: .empty)!)
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        defer {
            print("urlRequest: \(urlRequest)")
            print("urlRequest.allHTTPHeaderFields: \(String(describing: urlRequest.allHTTPHeaderFields))")
        }
        
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue(API.clientId, forHTTPHeaderField: "Autentia-Client-Id")
        
        switch self {
        case .getAudits, .getAudit, .reportAudit, .updateProfile:
            if let accessToken = OAuth2ClientHandler.shared.accessToken {
                urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        default: break
        }
        
        switch self {
        case .updateProfile:
            urlRequest.setValue("application/vnd.autentia.profile+json", forHTTPHeaderField: "Content-Type")
        default: break
        }
        
        switch self {
        case .updateProfile:
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
