//
//  Parameters.swift
//  TrustDeviceInfo
//
//  Created by Diego Villouta Fredes on 4/22/19.
//  Copyright © 2019 Jumpitt Labs. All rights reserved.
//

import Alamofire
import CoreTelephony
import DeviceKit

// MARK: - IdentityInfoDataSource
public protocol IdentityInfoDataSource {
    var dni: String {get}
    var name: String? {get}
    var lastname: String? {get}
    var email: String? {get}
    var phone: String? {get}
}

// MARK: - ClientCredentialsParameters
struct ClientCredentialsParameters: Parameterizable {
    var clientID: String?
    var clientSecret: String?
    
    let grantType = "client_credentials"
    
    public var asParameters: Parameters {
        guard
            let clientID = clientID,
            let clientSecret = clientSecret else {
                return [:]
        }
        
        return [
            "client_id": clientID,
            "client_secret": clientSecret,
            "grant_type": grantType
        ]
    }
}

// MARK: - AppStateParameters
struct AppStateParameters: Parameterizable {
    var dni: String?
    var bundleID: String?
    
    private var trustID: String? {
        return trustIDManager.getTrustID()
    }
    
    private var trustIDManager: TrustIDManagerProtocol {
        let serviceName = Identify.serviceName
        let accessGroup = Identify.accessGroup
        
        return TrustIDManager(serviceName: serviceName, accessGroup: accessGroup)
    }
    
    public var asParameters: Parameters {
        guard
            let trustID = trustID,
            let dni = dni,
            let bundleID = bundleID else {
                return [:]
        }
        
        return [
            "trust_id": trustID,
            "dni": dni,
            "bundle_id": bundleID
        ]
    }
}

// MARK: - RegisterFirebaseTokenParameters
struct RegisterFirebaseTokenParameters: Parameterizable {
    var firebaseToken: String?
    var bundleID: String?
    
    private var trustID: String? {
        return trustIDManager.getTrustID()
    }
    
    private var trustIDManager: TrustIDManagerProtocol {
        let serviceName = Identify.serviceName
        let accessGroup = Identify.accessGroup
        
        return TrustIDManager(serviceName: serviceName, accessGroup: accessGroup)
    }
    
    public var asParameters: Parameters {
        guard
            let trustID = trustID,
            let firebaseToken = firebaseToken,
            let bundleID = bundleID else {
                return [:]
        }
        
        return [
            "trust_id": trustID,
            "firebase_token": firebaseToken,
            "bundle_id": bundleID,
            "platform": "IOS"
        ]
    }
}

// MARK: - DeviceInfoParameters
struct DeviceInfoParameters: Parameterizable {
    var identityInfo: IdentityInfoDataSource?
    var networkInfo: CTTelephonyNetworkInfo?
    var trustID: String? {
        return trustIDManager.getTrustID()
    }
    
    private var trustIDManager: TrustIDManagerProtocol {
        let serviceName = Identify.serviceName
        let accessGroup = Identify.accessGroup
        
        return TrustIDManager(serviceName: serviceName, accessGroup: accessGroup)
    }
    
    public var asParameters: Parameters {
        let systemName = "iOS"
        let device = Device.current
        let uiDevice = UIDevice()
        
        var trustIDManager: TrustIDManagerProtocol {
            let serviceName = Identify.serviceName
            let accessGroup = Identify.accessGroup
            
            return TrustIDManager(serviceName: serviceName, accessGroup: accessGroup)
        }
        
        var parameters: Parameters = [:]
        
        var deviceParameters: [String : Any] = [
            "activeCPUs": Sysctl.activeCPUs,
            "hostname": Sysctl.hostName,
            "model": Sysctl.machine,
            "machine": Sysctl.model,
            "osRelease": Sysctl.osRelease,
            "osType": Sysctl.osType,
            "osVersion": Sysctl.osVersion,
            "version": Sysctl.version,
            "description": device.description,
            "screenBrightness": device.screenBrightness,
            "screenDiagonalLength": device.diagonal,
            "totalDiskSpace": DiskStatus.totalDiskSpace,
            "identifierForVendor": uiDevice.identifierForVendor?.uuidString ?? "",
            "system_name": systemName
        ]
        
        if let batteryLevel = device.batteryLevel {
            deviceParameters.updateValue(batteryLevel, forKey: "batteryLevel")
        }
        
        if let localizedModel = device.localizedModel {
            deviceParameters.updateValue(localizedModel, forKey: "localizedModel")
        }
        
        if let deviceModel = device.model {
            deviceParameters.updateValue(deviceModel, forKey: "deviceModel")
        }
        
        if let name = device.name {
            deviceParameters.updateValue(name, forKey: "name")
        }
        
        if let screenPPI = device.ppi {
            deviceParameters.updateValue(screenPPI, forKey: "screenPPI")
        }
        
        if let systemOS = device.systemName {
            deviceParameters.updateValue(systemOS, forKey: "systemOS")
        }
        
        if let systemVersion = device.systemVersion {
            deviceParameters.updateValue(systemVersion, forKey: "systemVersion")
        }
        
        parameters.updateValue(deviceParameters, forKey: "device")
        
        if let trustID = trustIDManager.getTrustID() {
            parameters.updateValue(trustID, forKey: "trust_id")
        }
        
        if let identityInfo = identityInfo {
            var identity = ["dni": identityInfo.dni]
            
            if let name = identityInfo.name {
                identity.updateValue(name, forKey: "name")
            }
            
            if let lastname = identityInfo.lastname {
                identity.updateValue(lastname, forKey: "lastname")
            }
            
            if let email = identityInfo.email {
                identity.updateValue(email, forKey: "email")
            }
            
            if let phone = identityInfo.phone {
                identity.updateValue(phone, forKey: "phone")
            }
            
            parameters.updateValue(identity, forKey: "identity")
        }
        
        guard
            let serviceSubscriberCellularProviders = networkInfo?.serviceSubscriberCellularProviders,
            !serviceSubscriberCellularProviders.isEmpty,
            let carrierKey =  serviceSubscriberCellularProviders.keys.first,
            let carrier = serviceSubscriberCellularProviders[carrierKey] else {
                return parameters
        }
        
        let carrierInfo = [
            [
                "carrierName": carrier.carrierName ?? "",
                "mobileCountryCode": carrier.mobileCountryCode ?? "",
                "mobileNetworkCode": carrier.mobileNetworkCode ?? "",
                "ISOCountryCode": carrier.isoCountryCode ?? "",
                "allowsVOIP": carrier.allowsVOIP ? "YES" : "NO"
            ]
        ]
        
        parameters.updateValue(carrierInfo, forKey: "sim")
        
        return parameters
    }
}
