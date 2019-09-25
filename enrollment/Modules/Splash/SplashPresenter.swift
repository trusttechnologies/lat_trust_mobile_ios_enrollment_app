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
    
    var isUpdatingLocation = false

    func onViewDidAppear() {
        interactor?.checkPermissions()
    }
}

extension SplashPresenter: SplashInteractorOutputProtocol {
    func callAlert(alertController: UIAlertController) {
        self.router?.presentPermissionsAlert(alertController: alertController)
    }
    
    func onGetAcceptedPermissions() {
        interactor?.getUser()
    }
    
    func onGetNotDeterminedPermissions() {
//        interactor?.checkPermissions()
    }
    
    func returnViewDidAppear() {
        self.onViewDidAppear()
    }
    
    func onGetUserSuccess() {
        interactor?.checkAccessToken()
    }
    
    func onGetUserFailure() {
        interactor?.clearData()
        router?.goToSessionMenuScreen()
    }
    
    func onCheckAccessTokenSuccess() {
        router?.goToMainScreen()
    }
    
    func onCheckAccessTokenFailure() {
        interactor?.checkRefreshToken()
    }
    
    func onRefreshTokenSuccess() {
        if let context = router?.viewController {
            interactor?.authenticate(context: context)
        }
    }
    
    func onRefreshTokenFailure() {
        interactor?.clearData()
    }
    
    func onAuthenticateSuccess() {
        router?.goToMainScreen()
    }
    
    func onAuthenticateFailure() {
        router?.goToSessionMenuScreen()
    }
    
    func onDataCleared() {
        router?.goToSessionMenuScreen()
    }
}
