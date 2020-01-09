//
//  DialogLegacyRouter.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 11-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation

class DialogLegacyRouter: DialogLegacyRouterProtocol{
    var viewController: UIViewController?
    
    static func createModule() -> DialogLegacyViewController {
        let view = DialogLegacyViewController.storyboardViewController()
        let presenter: DialogLegacyPresenterProtocol & DialogLegacyInteractorOutputProtocol = DialogLegacyPresenter()
        let interactor: DialogLegacyInteractorProtocol & CallbackDataManagerOuputProtocol = DialogLegacyInteractor()
        let router = DialogLegacyRouter()
        
        let callbackDataManager = CallbackDataManager()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.interactorOutput = presenter
        interactor.callbackDataManager = callbackDataManager
        
        router.viewController = view
        
        callbackDataManager.managerOutput = interactor
        
        
        return view
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
    
    func onActionButtonPressed() {
        //
    }
    
    
}

