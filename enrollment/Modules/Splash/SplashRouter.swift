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
        let presenter: SplashPresenterProtocol = SplashPresenter()
        let router = SplashRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        
        router.viewController = view
        
        return view
    }
    
    func goToLogin() {
        let sesionMenuVC = SesionMenuRouter.createModule()
        
        viewController?.present(sesionMenuVC, animated: true)
    }
}
