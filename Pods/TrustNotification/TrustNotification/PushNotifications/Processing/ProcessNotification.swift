//
//  HandlingNotification.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 10-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import TrustDeviceInfo

//MARK: UserNotifications Handling
extension PushNotifications: UNUserNotificationCenterDelegate, PushNotificationsProtocol{
    
    
    /**
     This function is executed when a notification is received in the foreground. This function is not called by the developer.
     
     When a notification is received, parse the data and with that object, call the function to present the notification according to the content (video, dialog, banner)
     */
    
    // MARK: Foreground Notification
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                        willPresent notification: UNNotification,
                                        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        notificationInfo.messageID = (notification.request.content.userInfo["gcm.message_id"] as! String)
        
        processNotification(userInfo: notification.request.content.userInfo)
        processNotificationInteractor?.onNotificationArrive(data: notificationInfo, action: "")
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(notification.request.content.userInfo)
        
        completionHandler([.alert, .badge, .sound])
    }
    
    
    /**
     This function is executed when a notification is received in the background. This function is not called by the developer.
     
     When a notification is received, parse the data and with that object, call the function to present the notification according to the content (video, dialog, banner)
     */
    
    // MARK: Background Notification
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            guard let data = response.notification.request.content.userInfo["data"] else {return}
            let notiInfo = parseStringNotification(content: response.notification.request.content.userInfo)
            let category = response.notification.request.content.categoryIdentifier
            
            switch category{
            case "url":
                switch response.actionIdentifier{
                    case "url":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[0].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[0].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    default:
                        self.processNotification(userInfo: response.notification.request.content.userInfo)
                        return
                }
            
            case "mail":
                switch response.actionIdentifier{
                    case "mail":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[0].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[0].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    default:
                        self.processNotification(userInfo: response.notification.request.content.userInfo)
                        return
                }
            
            case "call":
                switch response.actionIdentifier{
                    case "call":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[0].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[0].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    default:
                        self.processNotification(userInfo: response.notification.request.content.userInfo)
                        return
                }
            
            case "url-mail":
                switch response.actionIdentifier{
                    case "url":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[0].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[0].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    case "mail":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[1].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[1].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    default:
                        self.processNotification(userInfo: response.notification.request.content.userInfo)
                        return
                }
            
            case "url-call":
                switch response.actionIdentifier{
                    case "url":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[0].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[0].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    case "call":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[1].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[1].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    default:
                        self.processNotification(userInfo: response.notification.request.content.userInfo)
                        return
                }
            
            case "url-url":
                switch response.actionIdentifier{
                    case "url":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[0].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[0].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    case "url2":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[1].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[1].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    default:
                        self.processNotification(userInfo: response.notification.request.content.userInfo)
                        return
                }
            
            case "mail-mail":
                switch response.actionIdentifier{
                    case "mail":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[0].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[0].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    case "mail2":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[1].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[1].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    default:
                        self.processNotification(userInfo: response.notification.request.content.userInfo)
                        return
                }
            case "mail-call":
                switch response.actionIdentifier{
                    case "mail":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[0].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[0].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    case "call":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[1].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[1].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    default:
                        self.processNotification(userInfo: response.notification.request.content.userInfo)
                        return
                }
            
            case "mail-url":
                switch response.actionIdentifier{
                    case "mail":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[0].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[0].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    case "url":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[1].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[1].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    default:
                        self.processNotification(userInfo: response.notification.request.content.userInfo)
                        return
                }
                
            case "call-mail":
                switch response.actionIdentifier{
                    case "call":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[0].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[0].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    case "mail":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[1].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[1].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    default:
                        self.processNotification(userInfo: response.notification.request.content.userInfo)
                        return
                }
                
            case "call-call":
                switch response.actionIdentifier{
                    case "call":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[0].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[0].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    case "call2":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[1].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[1].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    default:
                        self.processNotification(userInfo: response.notification.request.content.userInfo)
                        return
                }
                
            case "call-url":
                switch response.actionIdentifier{
                    case "call":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[0].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[0].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    case "url":
                        switch notiInfo.type{
                            case "dialog", "banner":
                                let dialogNotification = parseDialog(content: notiInfo)
                                guard let stringUrl = dialogNotification.buttons?[1].action,
                                    let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                    return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            case "video":
                                let videoNotification = parseVideo(content: notiInfo)
                                let stringUrl = videoNotification.buttons[1].action
                                guard let url = URL(string: stringUrl) else {
                                    print("Error parsing the url")
                                return
                                }
                                if(verifyUrl(urlString: stringUrl)){
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }else{
                                    print("Invalid URL")
                                }
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            default:
                                return
                        }
                    default:
                        self.processNotification(userInfo: response.notification.request.content.userInfo)
                        return
                }
                
            default:
                print("Other Action")
                self.processNotification(userInfo: response.notification.request.content.userInfo)
            }
            
            completionHandler()
        }
        
    }
}

extension PushNotifications: ProcessNotificationInteractorOutputProtocol{
    
    func onReceptionConfirmationSuccess(userInfo: [AnyHashable: Any]){
        processNotification(userInfo: userInfo)
    }
    
    func onCallbackSuccess() {
        //
    }
    
    func onCallbackFailure() {
        //
    }
    
    
}
