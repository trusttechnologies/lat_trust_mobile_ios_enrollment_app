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
    var locationDataManager: LocationManagerProtocol? {get set}
    
    func checkIfUserHasLoggedIn() //Get User, Check AccessToken, Check RefreshToken
    func authorize(from context: AnyObject)
    
    func requestNotificationPermissions()
    func requestLocationPermissions()
    
    func cleanData()
}

// MARK: - InteractorOutput
protocol SplashInteractorOutputProtocol: AnyObject {
    func onUserHasLoggedInSuccess()
    func onUserHasLoggedInFailure()
    
    func onAuthorizeSuccess()
    func onAuthorizeFailure()
    
    func returnViewDidAppear()
    
    func onGetAllPermissionsAccepted()
    
    func onDataCleaned()
    func requestNotificationResponse()
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
}
