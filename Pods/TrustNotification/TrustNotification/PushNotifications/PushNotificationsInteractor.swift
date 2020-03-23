//
//  PushNotificationsInteractor.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 21-01-20.
//  Copyright © 2020 Trust. All rights reserved.
//

import Foundation

class PushNotificationsInteractor: PushNotificationsInteractorProtocol{
    var interactorOutput: PushNotificationsInteractorOutputProtocol?
    var callbackDataManager: CallbackDataManagerProtocol?
    var videoDownloadDataManager: VideoDownloadDataManager?
    
    func onNotificationArrive(data: NotificationInfo, action: String, state: String, errorMessage: String?) {
        callbackDataManager?.receptionConfirmation(data: data, action: "", state: state, errorMessage: nil)
    }
    
    func downloadVideo(data: NotificationInfo) {
        videoDownloadDataManager?.downloadVideo(url: data.videoNotification!.videoUrl)
    }
}

extension PushNotificationsInteractor: CallbackDataManagerOuputProtocol{
    func onReceptionConfirmationSuccess() {
        //
    }
    
    func onReceptionConfirmationFailure() {
        //
    }
    
    func onCallbackSuccess() {
        //
    }
    
    func onCallbackFailure() {
        //
    }
    
    
}

extension PushNotificationsInteractor: VideoDownloadDataManagerOutputProtocol{
    func onDownloadSuccess(with url: URL) {
        interactorOutput?.onDownloadVideoSuccess(with: url)
    }
    
    func onDownloadFailure() {
        //
    }
    
    
}
