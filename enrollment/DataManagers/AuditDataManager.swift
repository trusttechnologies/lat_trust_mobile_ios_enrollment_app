//
//  AuditDataManager.swift
//  enrollment
//
//  Created by Kevin Torres on 9/2/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Foundation
import CoreLocation
import Audit
import TrustDeviceInfo
import SystemConfiguration

// MARK: - AuditDataManagerProtocol
protocol AuditDataManagerProtocol: NSObjectProtocol {
    func createLoginAudit()
}

// MARK: - AuditDataManager
class AuditDataManager: NSObject, AuditDataManagerProtocol {
    let locationManager = CLLocationManager()
    
    func createLoginAudit() {
        guard let savedTrustId = Identify.shared.getTrustID() else { return }
        
        TrustAudit.shared.createAudit(trustID: savedTrustId, connectionType: "connectionType", connectionName: "connectionName", type: "trust identify", result: "success88", method: "method testing", operation: "operation testing")
    }
}

//    @objc dynamic public var auditType: String = ""
//    @objc dynamic public var platform: String = "" //iOS
//    @objc dynamic public var application: String = ""
//    @objc dynamic public var source: Source?
//        @objc dynamic public var trustID: String = "" ok
//        @objc dynamic public var appName: String = "" ok
//        @objc dynamic public var bundleID: String = ""
//        @objc dynamic public var latitude: String = ""
//        @objc dynamic public var longitude: String = ""
//        @objc dynamic public var connectionType: String = ""
//        @objc dynamic public var connectionName: String = ""
//        @objc dynamic public var appVersion: String = ""
//        @objc dynamic public var deviceName: String = ""
//        @objc dynamic public var osVersion: String = ""
//    @objc dynamic public var transaction: Transaction?
//        @objc dynamic public var type: String = ""
//        @objc dynamic public var result: String = ""
//        @objc dynamic public var timestamp: Int = 1
//        @objc dynamic public var method: String = ""
//        @objc dynamic public var operation: String = ""


