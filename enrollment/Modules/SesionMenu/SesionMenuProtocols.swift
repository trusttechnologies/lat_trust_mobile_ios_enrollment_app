//
//  SesionMenuProtocols.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - View
protocol SesionMenuViewProtocol: AnyObject {}

// MARK: - Interactor
protocol SesionMenuInteractorProtocol: AnyObject {
    var interactorOutput: SesionMenuInteractorOutput? {get set}
    var oauth2Manager: OAuth2ManagerProtocol? {get set}
    var userDataManager: UserDataManagerProtocol? {get set}
    
    func authorizeUser(from context: AnyObject)
    func getUserProfile()
}

// MARK: - InteractorOutput
protocol SesionMenuInteractorOutput: AnyObject {
    func onAuthorizeSuccess()
    func onAuthorizeFailure(with errorMessage: String)
    
    func onGetUserProfileResponse()
    func onGetUserProfileSuccess()
    func onGetUserProfileFailure(with errorMessage: String)
    
    func onUserDataSaved()
    
    func onMissingInfoFromRetrievedProfile()
}

// MARK: - Presenter
protocol SesionMenuPresenterProtocol: AnyObject {
    var view: SesionMenuViewProtocol? {get set}
    var interactor: SesionMenuInteractorProtocol? {get set}
    var router: SesionMenuRouterProtocol? {get set}
    
    func onLoginButtonPressed(from context: AnyObject)
}

// MARK: - Router
protocol SesionMenuRouterProtocol: AnyObject {
    var viewController: UIViewController? {get set}
    static func createModule() -> SesionMenuViewController
    
    func goToMainScreen()
    func presentAlertView(with errorMessage: String)
}
