//
//  ProcessNotificationInteractor.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 06-01-20.
//  Copyright © 2020 Trust. All rights reserved.
//

import Foundation

class ProcessNotificationInteractor: ProcessNotificationInteractorProtocol{
    weak var interactorOutput: ProcessNotificationInteractorOutputProtocol?
    
    var callbackDataManager: CallbackDataManagerProtocol? = CallbackDataManager()
    
    func onNotificationArrive(data: NotificationInfo, action: String) {
        callbackDataManager?.receptionConfirmation(data: data, action: "")
    }
    
    
}

extension ProcessNotificationInteractor: CallbackDataManagerOuputProtocol{
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
        interactorOutput?.onCallbackFailure()
    }
    
    
}
