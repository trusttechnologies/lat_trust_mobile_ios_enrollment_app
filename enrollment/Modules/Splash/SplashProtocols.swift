//
//  SplashProtocols.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - Interactor
protocol SplashInteractorProtocol: AnyObject {
    var interactorOutput: SplashInteractorOutput? {get set}
    
    var oauth2Manager: OAuth2ManagerProtocol? {get set}
    var userDataManager: UserDataManagerProtocol? {get set}
    
    func checkIfUserHasLoggedIn()
    func authorize(from context: AnyObject)
//    func updateFirebaseToken()
    func cleanData()
}

// MARK: - InteractorOutput
protocol SplashInteractorOutput: AnyObject {
    func onUserHasLoggedInSuccess()
    func onUserHasLoggedInFailure()
    
    func onAuthorizeSuccess()
    func onAuthorizeFailure()
    
    func onDataCleaned()
}

// MARK: - View
protocol SplashViewProtocol: AnyObject {}

// MARK: - Presenter
protocol SplashPresenterProtocol: AnyObject {
    var view: SplashViewProtocol? {get set}
    var router: SplashRouterProtocol? {get set}
    
    func onViewDidAppear()
}

// MARK: - Router
protocol SplashRouterProtocol: AnyObject {
    var viewController: UIViewController? {get set}
    
    static func createModule() -> SplashViewController
    func goToLogin()
}
