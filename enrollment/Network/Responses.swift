//
//  Responses.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import ObjectMapper

typealias CustomMappable = Mappable & CustomStringConvertible

// MARK: - BaseResponse<T: Mappable>
class BaseResponse<T: Mappable>: CustomMappable {
    var status: Int?
    var message: String?
    var sessionId: String?
    var result: T?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        sessionId <- map ["session_id"]
        result <- map["result"]
    }
}

// MARK: - EmptyResponse
class EmptyResponse: CustomMappable {
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {}
}

// MARK: - AuditsResponse
/*
class AuditsResponse: CustomMappable {
    var audits: [Audit]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        audits <- map["data"]
    }
}*/

// MARK: - ReportAuditResponse
class ReportAuditResponse: CustomMappable {
    var errors: [ReportAuditError]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        errors <- map["errors"]
    }
}

class ReportAuditError: CustomMappable {
    var status: Int?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["status"]
    }
}
