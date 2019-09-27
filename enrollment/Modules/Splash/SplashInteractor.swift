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

class SplashInteractor: NSObject, SplashInteractorProtocol, CLLocationManagerDelegate {
    var interactorOutput: SplashInteractorOutputProtocol?
    
    var oauth2Manager: OAuth2ManagerProtocol?
    
    var userDataManager: UserDataManagerProtocol?
    let locationManager = CLLocationManager()
    
    // MARK: - Persistence layer
    func getUser() {
        guard userDataManager?.getUser() != nil else {
            interactorOutput?.onGetUserFailure() // Get user nil, No user in data
            return
        }
        interactorOutput?.onGetUserSuccess() // Have an user in... Check Access token
    }

    func checkAccessToken() {
        print("--- Access Token: \(oauth2Manager?.getAccessToken())")
        
        guard oauth2Manager?.getAccessToken() != nil else {
            interactorOutput?.onCheckAccessTokenFailure() //Silentauth
            return
        }
        interactorOutput?.onCheckAccessTokenSuccess() //Go to main screen
    }
    
    func checkRefreshToken() {
        print("--- Refresh Token:: \(oauth2Manager?.getRefreshToken())")
        
        guard oauth2Manager?.getRefreshToken() != nil else {
            interactorOutput?.onRefreshTokenFailure()
            return
        }
//            interactorOutput?.onCheckAccessTokenSuccess() //Go to main screen

        interactorOutput?.onRefreshTokenSuccess() //authenticate
    }
    
    func authenticate(context: AnyObject) {
        oauth2Manager?.silentAuthorize(from: context)
    }
    
    // MARK: - Check location permissions
    func checkPermissions() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
            interactorOutput?.onGetAcceptedPermissions()
            return
        case .denied, .restricted:
            let alertController = UIAlertController(title: "Enrollment", message: "Acepte los permisos", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action) in alertController.dismiss(animated: true, completion: nil)
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                self.interactorOutput?.returnViewDidAppear()
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { (action) in alertController.dismiss(animated: true, completion: nil)
                self.interactorOutput?.returnViewDidAppear()
            }))
            
            interactorOutput?.callAlert(alertController: alertController)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            interactorOutput?.onGetAcceptedPermissions()
            break
        }
        locationManager.delegate = self

        //        interactor?.getUser()
    }
    
    func clearData() {
        userDataManager?.deleteAll(completion: nil)
        oauth2Manager?.clearTokens()
        
        let realm = try! Realm()

        try! realm.write {
            realm.deleteAll()
            
            interactorOutput?.onDataCleared()
        }
    }
}

extension SplashInteractor: OAuth2ManagerOutputProtocol {
    func onAuthorizeSuccess() {
        print("onAuthorizeSuccess")
    }
    
    func onAuthorizeFailure(with errorMessage: String) {
        print("onAuthorizeFailure")
    }
    
    func onSilentAuthorizeSuccess() {
        interactorOutput?.onAuthenticateSuccess()
    }
    
    func onSilentAuthorizeFailure() {
        interactorOutput?.onAuthenticateFailure()
    }
}
