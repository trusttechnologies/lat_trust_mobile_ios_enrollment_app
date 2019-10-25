//
//  AppDelegate.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import TrustDeviceInfo
import Audit
import TrustNotification
import Sentry

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let notifications = PushNotifications(clientId: "adcc11078bee4ba2d7880a48c4bed02758a5f5328276b08fa14493306f1e9efb", clientSecret: "1f647aab37f4a7d7a0da408015437e7a963daca43da06a7789608c319c2930bd", serviceName: "defaultServiceName", accesGroup: "P896AB2AMC.trustID.appLib")
}

extension AppDelegate: TrustDeviceInfoDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // IQKeyboardManager Initialization
        // Create a Sentry client and start crash handler
        do {
            Client.shared = try Client(dsn: "https://f2798e2f783c4c448a1f2a3467695462@sentry.io/1776107")
            try Client.shared?.startCrashHandler()
        } catch let error {
            print("\(error)")
        }
        
        IQKeyboardManager.shared.enable = true
        
        let serviceName = "defaultServiceName"
        let accessGroup = "P896AB2AMC.trustID.appLib"
        let clientID = "adcc11078bee4ba2d7880a48c4bed02758a5f5328276b08fa14493306f1e9efb"
        let clientSecret = "1f647aab37f4a7d7a0da408015437e7a963daca43da06a7789608c319c2930bd"
        
        Identify.shared.trustDeviceInfoDelegate = self
        Identify.shared.set(serviceName: serviceName, accessGroup: accessGroup)
        Identify.shared.createClientCredentials(clientID: clientID, clientSecret: clientSecret)
        Identify.shared.setAppState(dni: "", bundleID: "com.trust.enrollment.ios")

        Identify.shared.enable()
        
        notifications.firebaseConfig(application: application)
            
        notifications.registerForRemoteNotifications()
        
        notifications.registerCustomNotificationCategory()
        
        TrustAudit.shared.set(serviceName: serviceName, accessGroup: accessGroup)
        TrustAudit.shared.createAuditClientCredentials(clientID: clientID, clientSecret: clientSecret)
        
        setInitialVC()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("URL: \(url)")
        
        saveOAuth2URLParametersFrom(url: url)
        OAuth2ClientHandler.shared.handleRedirectURL(url)

        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        notifications.clearBadgeNumber()
        
        guard let mainVC = application.topMostViewController() as? MainScreenViewController else {
            return
        }
        
        let oAuth2Manager = OAuth2Manager()
        
        oAuth2Manager.managerOutput = self
        oAuth2Manager.silentAuthorize(from: mainVC)
    }
    
    func onClientCredentialsSaved(savedClientCredentials: ClientCredentials) {
        //
        print("azzzzzza")
//        Identify.shared.setAppState(dni: "", bundleID: "com.trust.enrollment.ios")
    }
    
    func onTrustIDSaved(savedTrustID: String) {
        //
    }
    
    func onRegisterFirebaseTokenSuccess(responseData: RegisterFirebaseTokenResponse) {
        //
    }
    
    func onSendDeviceInfoResponse(status: ResponseStatus) {
        //
    }
}

// MARK: - OAuth2ManagerOutputProtocol
extension AppDelegate: OAuth2ManagerOutputProtocol {
    func onAuthorizeSuccess() {}
    
    func onAuthorizeFailure(with errorMessage: String) {}
    
    func onSilentAuthorizeSuccess() {}
     
    func onSilentAuthorizeFailure() {}
}

// MARK: - setInitialVC
extension AppDelegate {
    private func setInitialVC() {
        let splashVC = SplashRouter.createModule()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
    }
}

// MARK: - OAuth2 Methods
extension AppDelegate {
    private func saveOAuth2URLParametersFrom(url: URL) {
        guard
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryComponents = urlComponents.queryItems else {
                return
        }
        
        queryComponents.forEach {
            guard
                let key = UserDefaults.OAuth2URLData.StringDefaultKey(rawValue: $0.name),
                let value =  $0.value else {
                    return
            }
            
            UserDefaults.OAuth2URLData.set(value, forKey: key)
        }
    }
}


