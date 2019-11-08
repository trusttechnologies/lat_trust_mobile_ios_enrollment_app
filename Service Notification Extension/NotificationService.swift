//
//  NotificationService.swift
//  Service Notification Extension
//
//  Created by Kevin Torres on 10/3/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
        var bestAttemptContent: UNMutableNotificationContent?
        
        var downloadTask: URLSessionDownloadTask?
    
        var url:String?
        
        override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
            self.contentHandler = contentHandler
            bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
            
            let genericNotification = parseNotification(content: request.content.userInfo)
            switch genericNotification.type {
                case "notificationBody":
//                    let bodyNotification = parseBody(content: genericNotification)
                    url = genericNotification.notificationBody?.imageUrl
                case "notificationDialog":
                    let dialogNotification = parseDialog(content: genericNotification)
                    url = dialogNotification.imageUrl
                case "notificationVideo":
                    let videoNotification = parseVideo(content: genericNotification)
                    url = videoNotification.videoUrl
                default:
                    print("error: must specify a notification type")
            }
                                        
    
            if let urlString = url, let fileUrl = URL(string: urlString) {
                // Download the attachment
                URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                    if let location = location {
                    // Move temporary file to remove .tmp extension
                        let tmpDirectory = NSTemporaryDirectory()
                        let tmpFile = "file://".appending(tmpDirectory).appending(fileUrl.lastPathComponent)
                        let tmpUrl = URL(string: tmpFile)!
                        try! FileManager.default.moveItem(at: location, to: tmpUrl)

                        // Add the attachment to the notification content
                        if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
                            self.bestAttemptContent?.attachments = [attachment]
                        }
                    }
                    // Serve the notification content
                    self.contentHandler!(self.bestAttemptContent!)
                }.resume()
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
