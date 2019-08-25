//
//  WelcomeScreenRouter.swift
//  enrollment
//
//  Created by Kevin Torres on 8/24/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - WelcomeScreenRouterDelegate
protocol WelcomeScreenRouterDelegate: AnyObject {
    func onWelcomeScreenDismissed()
}

// MARK: - Router
class WelcomeScreenRouter: WelcomeScreenRouterProtocol {
    weak var viewController: UIViewController?
    weak var delegate: WelcomeScreenRouterDelegate?
    
    static func createModule(delegate: WelcomeScreenRouterDelegate? = nil) -> WelcomeScreenViewController {
        
        let view = WelcomeScreenViewController.storyboardViewController()
        let interactor = WelcomeScreenInteractor()
        let presenter: WelcomeScreenPresenterProtocol & WelcomeScreenInteractorOutput = WelcomeScreenPresenter()
        let router = WelcomeScreenRouter()
        
        let userDataManager = UserDataManager()
        
        view.presenter = presenter
        
        interactor.interactorOutput = presenter
        interactor.userDataManager = userDataManager
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        router.viewController = view
        router.delegate = delegate
        
        return view
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true) {
            [weak self] in
            
            guard let self = self else {
                return
            }
            
            self.delegate?.onWelcomeScreenDismissed()
        }
    }
}
