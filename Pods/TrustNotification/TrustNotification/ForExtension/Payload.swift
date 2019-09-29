//
//  Payload.swift
//  TrustNotification
//
//  Created by Cristian Parra on 12-09-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation
import UserNotifications

// This is a class created to establish the title and body of the notification through the paylod of the notification sent.

public class Payload: NSObject {
    
    /**
    Call this function in Service Notification Extension to establish the title and body of the push notification.
    - Parameters:
    - bestAttemptContent: Best Attemprt Content
    
    
    ### Usage Example: ###
    ````
    setTitleAndBody(bestAttemptContent: bestAttemptContent)
    ````
    */
    
    public func setTitleAndBody(bestAttemptContent: UNMutableNotificationContent?){
        
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
}
