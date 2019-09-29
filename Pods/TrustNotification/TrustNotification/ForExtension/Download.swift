//
//  Download.swift
//  ServiceNotificationExtension
//
//  Created by Cristian Parra on 09-09-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation
import UserNotifications

// This is a class created to download the resource to display in the push notification

public class FileDownloader: NSObject {
    
    /**
    Download background content
    */
    
    var downloadTask: URLSessionDownloadTask?
    
    /**
    Call this function in Service Notification Extension to download the content that will be displayed on the push notification.
    - Parameters:
    - urlString : Web address of content
    - contentHandler : Content Handler
    - bestAttemptContent: Best Attemprt Content
    
    
    ### Usage Example: ###
    ````
    fileDonwload( urlString: urlString, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
    ````
    */
    
    public func fileDonwload( urlString: String, contentHandler: ((UNNotificationContent) -> Void)? ,bestAttemptContent: UNMutableNotificationContent? ) -> Void {
        
        guard let url = URL(string: urlString) else {
            // Cannot create a valid URL, return early.
            contentHandler!(bestAttemptContent!)
            return
        }
        
        self.downloadTask = URLSession.shared.downloadTask(with: url) { (location, response, error) in
            if let location = location {
                let tmpDirectory = NSTemporaryDirectory()
                let tmpFile = "file://".appending(tmpDirectory).appending(url.lastPathComponent)
                
                let tmpUrl = URL(string: tmpFile)!
                try! FileManager.default.moveItem(at: location, to: tmpUrl)
                
                if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
                    bestAttemptContent?.attachments = [attachment]
                }
            }
            
            contentHandler!(bestAttemptContent!)
        }
        
        self.downloadTask?.resume()
    }
    
    /**
    Call this function in the Service notification extension to get the content url.
    - Parameters:
    - bestAttemptContent: Best Attemprt Content
    - contentHandler : Content Handler
    
    
    ### Usage Example: ###
    ````
    getURLpayload(bestAttemptContent: bestAttemptContent, contentHandler: contentHandler)
    ````
    */
    
    public func getURLpayload(bestAttemptContent: UNMutableNotificationContent?, contentHandler: ((UNNotificationContent) -> Void)? ) -> String {
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
                contentHandler!(bestAttemptContent!)
            }
        }
        return urlString!
    }
}
