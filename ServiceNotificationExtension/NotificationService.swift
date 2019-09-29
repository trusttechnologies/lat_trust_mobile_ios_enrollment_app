//
//  NotificationService.swift
//  ServiceNotificationExtension
//
//  Created by Kevin Torres on 9/27/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UserNotifications
import TrustNotification

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    var download = FileDownloader()
    var payload = Payload()

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
//            // Modify the notification content here...
//            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
//
//            contentHandler(bestAttemptContent)
            payload.setTitleAndBody(bestAttemptContent: bestAttemptContent)
            
            let urlString = download.getURLpayload(bestAttemptContent: bestAttemptContent, contentHandler: contentHandler)
            
            download.fileDonwload(urlString: urlString, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
