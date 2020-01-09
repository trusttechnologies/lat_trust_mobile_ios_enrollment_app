//
//  ProcessNotificationProtocols.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 06-01-20.
//  Copyright © 2020 Trust. All rights reserved.
//

import Foundation

protocol PushNotificationsProtocol: UNUserNotificationCenterDelegate{}

protocol ProcessNotificationInteractorProtocol: AnyObject {
    var interactorOutput: ProcessNotificationInteractorOutputProtocol? {get set}
    var callbackDataManager: CallbackDataManagerProtocol? {get set}
    
    func onNotificationArrive(data: NotificationInfo, action: String)
}

protocol ProcessNotificationInteractorOutputProtocol: AnyObject {
    func onReceptionConfirmationSuccess(userInfo: [AnyHashable: Any])
    func onCallbackSuccess()
    func onCallbackFailure()
}

protocol ProcessNotificationRouterProtocol: AnyObject {
    func presentDialog()
    func presentVideo()
}
