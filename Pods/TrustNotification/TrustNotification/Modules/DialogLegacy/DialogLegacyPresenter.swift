//
//  DialogLegacyPresenter.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 11-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation

class DialogLegacyPresenter: DialogLegacyPresenterProtocol{
    var view: DialogLegacyViewProtocol?
    var interactor: DialogLegacyInteractorProtocol?
    var router: DialogLegacyRouterProtocol?
    
    func onCloseButtonPressed() {
        interactor?.onUserPerformAction(data: view!.data!, action: "close")
    }
    
    func onActionButtonPressed(action: String) {
        if let url = URL(string: action) {
            UIApplication.shared.open(url , options: [:], completionHandler: nil)
            interactor?.onUserPerformAction(data: view!.data!, action: action)
        }
    }
}

extension DialogLegacyPresenter: DialogLegacyInteractorOutputProtocol{
    func onCallbackSuccess() {
        router?.dismiss()
    }
    
    func onCallbackFailure() {
        //
    }
    
}
