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
        
        override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
            self.contentHandler = contentHandler
            bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
            
            func fileDonwload( urlString: String) -> Void {
                
                guard let url = URL(string: urlString) else {
                    // Cannot create a valid URL, return early.
                    contentHandler(bestAttemptContent!)
                    return
                }
                
                self.downloadTask = URLSession.shared.downloadTask(with: url) { (location, response, error) in
                    if let location = location {
                        let tmpDirectory = NSTemporaryDirectory()
                        let tmpFile = "file://".appending(tmpDirectory).appending(url.lastPathComponent)
                        
                        let tmpUrl = URL(string: tmpFile)!
                        try! FileManager.default.moveItem(at: location, to: tmpUrl)
                        
                        if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
                            self.bestAttemptContent?.attachments = [attachment]
                        }
                    }
                    
                    self.contentHandler!(self.bestAttemptContent!)
                }
                
                self.downloadTask?.resume()
            }
            
            func getURLpayload() -> String {
                var urlString:String?
                if let url = bestAttemptContent!.userInfo["data"] as? Dictionary<AnyHashable, Any> {
                    
                    if let imageUrl = url["notificationBody"] as? Dictionary<AnyHashable, Any> {
                        
                        urlString = imageUrl["image_url"] as? String
                        
                    }
                    else if let videoURL = url["notificationVideo"] as? Dictionary<AnyHashable, Any> {
                        
                        urlString = videoURL["video_url"] as? String
                        
                    }
                    else if let imageUrl = url["notificationDialog"] as? Dictionary<AnyHashable, Any> {
                        
                        urlString = imageUrl["image_url"] as? String
                        
                    }
                    else {
                        // Nothing to add to the push, return early.
                        contentHandler(bestAttemptContent!)
                    }
                }
                return urlString!
            }
            
            func setTitleAndBody(){
                
                if let data = bestAttemptContent?.userInfo["data"] as? Dictionary<AnyHashable, Any>{
                    if let type = data["notificationBody"] as? Dictionary<AnyHashable, Any>{
                        
                        if let title = type["text_title"] as? String{
                            bestAttemptContent?.title = title
                        }
                        if let body = type["text_body"] as? String{
                            bestAttemptContent?.body = body
                        }
                        
                    }
                        
                    else if let type = data["notificationDialog"] as? Dictionary<AnyHashable, Any>{
                        if let title = type["text_title"] as? String{
                            bestAttemptContent?.title = title
                        }
                        
                        if let body = type["text_body"] as? String{
                            bestAttemptContent?.body = body
                        }
                    }
                        
                    else if let type = data["notificationVideo"] as? Dictionary<AnyHashable, Any>{
                        
                        if let title = type["text_title"] as? String{
                            bestAttemptContent?.title = title
                        }
                        if let body = type["text_body"] as? String{
                            bestAttemptContent?.body = body
                        }
                    }
                }
            }
            
            if let bestAttemptContent = bestAttemptContent {
    //            // Modify the notification content here...
    //            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
    //
                setTitleAndBody()
                let urlString = getURLpayload()
                fileDonwload( urlString: urlString)
                
    //            contentHandler(bestAttemptContent)
             
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
