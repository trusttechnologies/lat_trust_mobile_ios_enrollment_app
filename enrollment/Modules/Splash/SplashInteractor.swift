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

class SplashInteractor: SplashInteractorProtocol {
    var interactorOutput: SplashInteractorOutputProtocol?
    
    var oauth2Manager: OAuth2ManagerProtocol?
    
    var userDataManager: UserDataManagerProtocol?
    let locationManager = CLLocationManager()

    
    func getUser() {
        if userDataManager?.getUser() != nil {
            interactorOutput?.onGetUserSuccess() //Check Access token
        } else {
            interactorOutput?.onGetUserFailure()
        }
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

    func checkAccessToken() {
        print("--- Access Token: \(oauth2Manager?.getAccessToken())")
        if oauth2Manager?.getAccessToken() != nil {
            interactorOutput?.onCheckAccessTokenSuccess() //Go to main screen
        } else {
            interactorOutput?.onCheckAccessTokenFailure() //Silentauth
        }
    }
    
    func checkRefreshToken() {
        print("--- Refresh Token:: \(oauth2Manager?.getRefreshToken())")
        if oauth2Manager?.getRefreshToken() != nil {
            interactorOutput?.onCheckAccessTokenSuccess() //Go to main screen

//            interactorOutput?.onRefreshTokenSuccess() //authenticate
        } else {
            interactorOutput?.onRefreshTokenFailure()
        }
    }
    
    func authenticate(context: AnyObject) {
        oauth2Manager?.silentAuthorize(from: context)
    }
    
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
        //        interactor?.getUser()
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
