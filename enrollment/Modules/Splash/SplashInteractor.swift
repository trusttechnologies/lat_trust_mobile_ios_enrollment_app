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
            break
        case .authorizedAlways, .authorizedWhenInUse:
            interactorOutput?.onGetAcceptedPermissions()
            break
        }
        locationManager.delegate = self

        //        interactor?.getUser()
    }
    
    func cleanData() {
        userDataManager?.deleteAll(completion: nil)
        oauth2Manager?.clearTokens()
        
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
