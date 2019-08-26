//
//  SesionMenuRouter.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - Router
class SesionMenuRouter: SesionMenuRouterProtocol {
    
    var viewController: UIViewController?
    
    static func createModule() -> SesionMenuViewController {
        
        let view = SesionMenuViewController.storyboardViewController()
        let interactor: SesionMenuInteractor & OAuth2ManagerOutputProtocol = SesionMenuInteractor()
        let presenter: SesionMenuPresenterProtocol & SesionMenuInteractorOutput = SesionMenuPresenter()
        let router = SesionMenuRouter()
        
        let oauth2Manager = OAuth2Manager()
        let userDataManager = UserDataManager()
        
        view.presenter = presenter
        
        interactor.interactorOutput = presenter
        interactor.oauth2Manager = oauth2Manager
        interactor.userDataManager = userDataManager
        
        oauth2Manager.managerOutput = interactor
        
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        router.viewController = view
        
        return view
    }
    
    func goToMainScreen() {
        let mainScreenVC = MainScreenRouter.createModule()
        
        viewController?.present(mainScreenVC, animated: true)
    }
    
    func goToWelcomeScreen() {
        let welcomeScreenVC = WelcomeScreenRouter.createModule(delegate: self)
        
        viewController?.present(welcomeScreenVC, animated: true)
    }
    
    func presentAlertView(with errorMessage: String) {
        viewController?.presentAlertView(type: .customMessage(message: errorMessage))
    }
}

// MARK: - WelcomeScreenDelegate
extension SesionMenuRouter: WelcomeScreenRouterDelegate {
    func onWelcomeScreenDismissed() {
        goToMainScreen()
    }
}


/*
// MARK: - WelcomeScreenDelegate
extension SesionMenuRouter: UserDataRequestScreenRouterDelegate {
    func onUserDataRequestScreenDismissed() {
        goToWelcomeScreen()
    }
}
*/
