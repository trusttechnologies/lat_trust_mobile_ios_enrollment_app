//
//  MainScreenRouter.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - Router
class MainScreenRouter: MainScreenRouterProtocol {
    var viewController: UIViewController?
    
    static func createModule() -> MainScreenViewController {
        
        let view = MainScreenViewController.storyboardViewController()
        let interactor: MainScreenInteractorProtocol = MainScreenInteractor()
        let presenter: MainScreenPresenterProtocol & MainScreenInteractorOutput = MainScreenPresenter()
        let router = MainScreenRouter()
        
        let userDataManager = UserDataManager()
        
        view.presenter = presenter

        interactor.interactorOutput = presenter
        interactor.userDataManager = userDataManager
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        router.viewController = view
        
        return view
    }
    
    func goToMainScreen() {
        viewController?.dismiss(animated: true)
    }
    
    func presentAlertView(with message: String, acceptAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        viewController?.presentAlertView(
            type: .customMessage(message: message),
            acceptAction: acceptAction,
            cancelAction: cancelAction
        )
    }
}
