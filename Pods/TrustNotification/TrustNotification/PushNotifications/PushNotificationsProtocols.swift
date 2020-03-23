//
//  PushNotificationsProtocols.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 21-01-20.
//  Copyright © 2020 Trust. All rights reserved.
//

import Foundation
import FirebaseMessaging

//MARK:- Similar to Router
protocol PushNotificationsInitProtocol: MessagingDelegate{
    var pushNotificationsProcessor: PushNotificationsProcessor? {get set}
    
    func initTrustNotifications()
    func presentDialog(content: NotificationInfo)
    func presentVideo(content: NotificationInfo)
    
}

//MARK:- Similar to Presenter
protocol PushNotificationsProcessorProtocol: UNUserNotificationCenterDelegate{
    var interactor: PushNotificationsInteractorProtocol? { get set }
    var router: PushNotificationsInitProtocol? { get set }
    func processNotification(userInfo: [AnyHashable : Any])
}

//MARK:- Interactor
protocol PushNotificationsInteractorProtocol{
    var interactorOutput: PushNotificationsInteractorOutputProtocol? {get set}
    var callbackDataManager: CallbackDataManagerProtocol? {get set}
    var videoDownloadDataManager: VideoDownloadDataManager? {get set}
    func onNotificationArrive(data: NotificationInfo, action: String, state: String, errorMessage: String?)
    func downloadVideo(data: NotificationInfo)
}

//MARK:- Interactor Output
protocol PushNotificationsInteractorOutputProtocol {
    func onReceptionConfirmationSuccess(userInfo: [AnyHashable: Any])
    func onCallbackSuccess()
    func onCallbackFailure()
    func onDownloadVideoSuccess(with url: URL)
    func onDownloadVideoFailure()
}
