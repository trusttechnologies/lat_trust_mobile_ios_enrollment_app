//
//  AppDelegate.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
}

extension AppDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // IQKeyboardManager Initialization
        IQKeyboardManager.shared.enable = true
        
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
        guard let mainVC = application.topMostViewController() as? MainScreenViewController else {
            return
        }
        
        let oAuth2Manager = OAuth2Manager()
        
        oAuth2Manager.managerOutput = self
        oAuth2Manager.silentAuthorize(from: mainVC)
    }
}

// MARK: - OAuth2ManagerOutputProtocol
extension AppDelegate: OAuth2ManagerOutputProtocol {
    func onAuthorizeSuccess() {}
    
    func onAuthorizeFailure(with errorMessage: String) {}
    
    /*func onSilentAuthorizeSuccess() {
     guard UserDefaults.standard.bool(forKey: .hasBeenOpenedFromRemoteNotificationKey) else {
     UserDefaults.standard.removeObject(forKey: .hasBeenOpenedFromRemoteNotificationKey)
     UserDefaults.standard.removeObject(forKey: .auditIDKey)
     return
     }
     
     if let receivedAuditID = UserDefaults.standard.string(forKey: .auditIDKey) {
     handleNotification(with: receivedAuditID)
     UserDefaults.standard.removeObject(forKey: .auditIDKey)
     }
     }
     
     func onSilentAuthorizeFailure() {}*/
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


