//
//  SplashRouter.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - Router
class SplashRouter: SplashRouterProtocol {
    var viewController: UIViewController?
    
    static func createModule() -> SplashViewController {
        let view = SplashViewController.storyboardViewController()
        let interactor: SplashInteractorProtocol & OAuth2ManagerOutputProtocol = SplashInteractor()
        let presenter: SplashPresenterProtocol & SplashInteractorOutputProtocol = SplashPresenter()
        let router = SplashRouter()

        let oauth2Manager = OAuth2Manager()
        let userDataManager = UserDataManager()

        view.presenter = presenter

        interactor.interactorOutput = presenter
        interactor.oauth2Manager = oauth2Manager
        interactor.userDataManager = userDataManager

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
    
    func goToSesionMenuScreen() {
        let sesionMenuScreenVC = SesionMenuRouter.createModule()
        viewController?.present(sesionMenuScreenVC, animated: true)
    }
}
