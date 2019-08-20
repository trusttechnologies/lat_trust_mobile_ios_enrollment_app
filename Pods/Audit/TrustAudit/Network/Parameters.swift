//
//  Parameters.swift
//  TrustAudit
//
//  Created by Kevin Torres on 8/14/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Alamofire
import CoreTelephony

// MARK: - CreateAuditParameters
public struct CreateAuditParameters: Parameterizable {
    public var auditType: String
    public var platform: String
    public var application: String
    public var source: Source
    public var transaction: Transaction
    
    public init(auditType: String, platform: String, application: String, source: Source, transaction: Transaction) {
        self.auditType = auditType
        self.platform = platform
        self.application = application
        self.source = source
        self.transaction = transaction
    }
    
    public var asParameters: Parameters {
        return [
            "type_audit": auditType,
            "platform": platform,
            "application": application,
            "source": source.asParameters,
            "transaction": transaction.asParameters
        ]
    }
}

// MARK: - Source
public struct Source: Parameterizable {
    private var trustID: String? {
        return TrustAudit.trustID
        //return TrustDeviceInfo.shared.getTrustID()
    }
    
    public var appName: String
    public var bundleID: String
    public var latitude: String
    public var longitude: String
    public var connectionType: String
    public var connectionName: String
    public var appVersion: String
    public var deviceName: String
    public var osVersion: String
    
    public init(appName: String, bundleID: String, latitude: String, longitude: String, connectionType: String, connectionName: String, appVersion: String, deviceName: String, osVersion: String) {
        self.appName = appName
        self.bundleID = bundleID
        self.latitude = latitude
        self.longitude = longitude
        self.connectionType = connectionType
        self.connectionName = connectionName
        self.appVersion = appVersion
        self.deviceName = deviceName
        self.osVersion = osVersion
    }
    
    public var asParameters: Parameters {
        guard let trustID = trustID else {return [:]}
        
        return [
            "trust_id": trustID,
            "app_name": appName,
            "bundle_id": bundleID,
            "os": "IOS",
            "os_version": osVersion ?? .zero,
            "device_name": deviceName,
            "latGeo": latitude,
            "lonGeo": longitude,
            "connection_type": connectionType,
            "connection_name": connectionName,
            "version_app": appVersion
        ]
    }
}

// MARK: - Transaction
public struct Transaction: Parameterizable {
    public var type: String
    public var result: String
    public var timestamp: Int
    public var method: String
    public var operation: String
    
    public init(type: String, result: String, timestamp: Int, method: String, operation: String) {
        self.type = type
        self.result = result
        self.timestamp = timestamp
        self.method = method
        self.operation = operation
    }
    
    public var asParameters: Parameters {
        return [
            "type": type,
            "result": result,
            "timestamp": timestamp,
            "method": method,
            "operation": operation
        ]
    }
}

