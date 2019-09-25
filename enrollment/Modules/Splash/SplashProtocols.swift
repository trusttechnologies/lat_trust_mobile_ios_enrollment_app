//
//  SplashProtocols.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - View
protocol SplashViewProtocol: AnyObject {}

// MARK: - Interactor
protocol SplashInteractorProtocol: AnyObject {
    var interactorOutput: SplashInteractorOutputProtocol? {get set}
    
    var oauth2Manager: OAuth2ManagerProtocol? {get set}
    var userDataManager: UserDataManagerProtocol? {get set}

    func getUser()
    
    func checkAccessToken()
    func checkRefreshToken()
    func authenticate(context: AnyObject)
    func checkPermissions()
    
    func clearData()
}

// MARK: - InteractorOutput
protocol SplashInteractorOutputProtocol: AnyObject {
    func onGetUserSuccess()
    func onGetUserFailure()
    
    func onCheckAccessTokenSuccess()
    func onCheckAccessTokenFailure()
    func onRefreshTokenSuccess()
    func onRefreshTokenFailure()
    func onAuthenticateSuccess()
    func onAuthenticateFailure()
    
    func onGetAcceptedPermissions()
    func onGetNotDeterminedPermissions()
    func returnViewDidAppear()
    func callAlert(alertController: UIAlertController)
    
    func onDataCleared()
}

// MARK: - Presenter
protocol SplashPresenterProtocol: AnyObject {
    var view: SplashViewProtocol? {get set}
    var router: SplashRouterProtocol? {get set}
    var interactor: SplashInteractorProtocol? {get set}

    func onViewDidAppear()
}

// MARK: - Router
protocol SplashRouterProtocol: AnyObject {
    var viewController: UIViewController? {get set}
    
    static func createModule() -> SplashViewController
    func goToMainScreen()
    func goToSessionMenuScreen()
    func presentPermissionsAlert(alertController: UIAlertController)
}
