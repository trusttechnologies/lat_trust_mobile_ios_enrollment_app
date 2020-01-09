//
//  DialogLegacyInteractor.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 11-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation

class DialogLegacyInteractor: DialogLegacyInteractorProtocol{
    var interactorOutput: DialogLegacyInteractorOutputProtocol?
    
    var callbackDataManager: CallbackDataManagerProtocol?
    
    func onUserPerformAction(data: NotificationInfo, action: String) {
        callbackDataManager?.callback(data: data, action: action)
    }
    
    func onShowNotificationError() {
        //
    }
    
    
}

extension DialogLegacyInteractor: CallbackDataManagerOuputProtocol{
    func onReceptionConfirmationSuccess() {
        //
    }
    
    func onReceptionConfirmationFailure() {
        //
    }
    
    func onCallbackSuccess() {
        interactorOutput?.onCallbackSuccess()
    }
    
    func onCallbackFailure() {
        //
    }
    
    
}
