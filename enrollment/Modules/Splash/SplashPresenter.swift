//
//  SplashPresenter.swift
//  enrollment
//
//  Created by Kevin Torres on 8/29/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class SplashPresenter: SplashPresenterProtocol {
    var view: SplashViewProtocol?
    
    var router: SplashRouterProtocol?
    
    var interactor: SplashInteractorProtocol?
    
    func onViewDidAppear() {
        interactor?.requestNotificationPermissions()

//        DispatchQueue.global().async {
//            self.interactor?.requestNotificationPermissions()
//        }
//        DispatchQueue.main.async {
//        }
    }
}

// MARK: - InteractorOutput
extension SplashPresenter: SplashInteractorOutputProtocol {
    // MARK: - Splash login
    func onUserHasLoggedInSuccess() {
        if let context = router?.viewController {
            interactor?.authorize(from: context)
        }
    }
    
    func onUserHasLoggedInFailure() {
        interactor?.cleanData()
    }
    
    func onAuthorizeSuccess() {
        router?.goToMainScreen()
    }
    
    func onAuthorizeFailure() {
        router?.goToSessionMenuScreen()
    }
    
    func onDataCleaned() {
        router?.goToSessionMenuScreen()//die
    }
    
    func returnViewDidAppear() {
        self.onViewDidAppear()
    }
    
    func onGetAllPermissionsAccepted() {
        interactor?.checkIfUserHasLoggedIn()
    }
    
    func requestNotificationResponse() {
        interactor?.requestLocationPermissions()
    }
}
