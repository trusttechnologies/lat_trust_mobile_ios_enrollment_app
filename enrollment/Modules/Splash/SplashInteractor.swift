//
//  SplashInteractor.swift
//  enrollment
//
//  Created by Kevin Torres on 8/29/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import RealmSwift

class SplashInteractor: NSObject, SplashInteractorProtocol, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    var interactorOutput: SplashInteractorOutputProtocol?
    
    var oauth2Manager: OAuth2ManagerProtocol?
    var userDataManager: UserDataManagerProtocol?
    var locationDataManager: LocationManagerProtocol?
    
    let locationManager = CLLocationManager()
    
    // MARK: - Checking user
    func checkIfUserHasLoggedIn() { // * 1 Get user -> 2 check access token -> 3 check refresh token
        guard userDataManager?.getUser() != nil else { // 1
            interactorOutput?.onUserHasLoggedInFailure() //Not user, clear data
            return
        }
        
        guard oauth2Manager?.getAccessToken != nil else { // 2
            guard oauth2Manager?.getRefreshToken != nil else { //3
                interactorOutput?.onUserHasLoggedInFailure()
                return
            }

            interactorOutput?.onUserHasLoggedInSuccess()
            return
        }

        interactorOutput?.onUserHasLoggedInSuccess()
    }
    
    func authorize(from context: AnyObject) {
        oauth2Manager?.silentAuthorize(from: context)
    }
    
    
    // MARK: - REQUEST PERMISSIONS --------------------------------------------------------
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { //decline
                self.interactorOutput?.requestNotificationResponse()
                return
            }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            self.interactorOutput?.requestNotificationResponse()
        }
    }
   
    
    func requestLocationPermissions() {
        let status = CLLocationManager.authorizationStatus()
        locationManager.delegate = self // ...
        
        if status == .notDetermined {
//            locationManager.requestAlwaysAuthorization() //Request permission
            locationManager.requestWhenInUseAuthorization() //Request permission)
        }
        if status == .denied {
            self.interactorOutput?.onGetAllPermissionsAccepted()

            print("Deined Location Permissions")
        }
        if status == .restricted {
            print("Restricted Location Permissions");
        }
        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            DispatchQueue.main.async { //!
                self.interactorOutput?.onGetAllPermissionsAccepted()
//            }
        }
    }
    
    func cleanData() {
        userDataManager?.deleteAll(completion: nil)
        oauth2Manager?.clearTokens() //
        
        let realm = try! Realm()

        try! realm.write {
            realm.deleteAll()
            
            interactorOutput?.onDataCleaned()
        }
    }
}

// MARK: - OAuth2ManagerOutputProtocol
extension SplashInteractor: OAuth2ManagerOutputProtocol {
    func onAuthorizeSuccess() {
        print("onAuthorizeSuccess")
    }
    
    func onAuthorizeFailure(with errorMessage: String) {
        print("onAuthorizeFailure")
    }
    
    func onSilentAuthorizeSuccess() {
        interactorOutput?.onAuthorizeSuccess()
    }
    
    func onSilentAuthorizeFailure() {
        interactorOutput?.onAuthorizeFailure()
    }
}

// MARK: - Listener location permission response
extension SplashInteractor {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        interactorOutput?.onGetAllPermissionsAccepted()
    }
}

extension SplashInteractor: LocationManagerOutputProtocol {
    
    func requestNotificationFail() {
        //TODO
    }
    
    func requestLocationFail() {
        //TODO
    }
}
