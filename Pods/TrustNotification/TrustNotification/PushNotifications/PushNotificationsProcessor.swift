//
//  PushNotificationsProcessor.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 21-01-20.
//  Copyright © 2020 Trust. All rights reserved.
//

import Foundation
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import TrustDeviceInfo

class PushNotificationsProcessor: NSObject, UNUserNotificationCenterDelegate{
    //MARK:- Architecture Vars
    var interactor: PushNotificationsInteractorProtocol?
    var router: PushNotificationsInitProtocol?
    
    //MARK:- Private vars
    private var notificationInfo: NotificationInfo = NotificationInfo(){
        didSet{
            notificationInfo.trustID = KeychainWrapper.standard.string(forKey: "trustID")
            notificationInfo.bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken")
        }
    }
    
    //MARK:- Receive notifications
    /**
     This function is executed when a notification is received in the foreground. This function is not called by the developer.
     
     When a notification is received, parse the data and with that object, call the function to present the notification according to the content (video, dialog, banner)
     */
    
    // MARK: Foreground Notification
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        notificationInfo.messageID = (notification.request.content.userInfo["gcm.message_id"] as! String)
        interactor?.onNotificationArrive(data: notificationInfo, action: "", state: "_success", errorMessage: nil)
        processNotification(userInfo: notification.request.content.userInfo)
        
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
            
            guard response.notification.request.content.userInfo["data"] != nil else {return}
            let notiInfo = parseStringNotification(content: response.notification.request.content.userInfo)
            let category = response.notification.request.content.categoryIdentifier
            self.notificationInfo.type = notiInfo.type
            self.interactor?.onNotificationArrive(data: self.notificationInfo, action: response.actionIdentifier, state: "_success", errorMessage: nil)
            
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
                self.interactor?.onNotificationArrive(data: self.notificationInfo, action: "", state: "_success", errorMessage: nil)
            }
            
            completionHandler()
        }
        
    }
    
}

extension PushNotificationsProcessor: PushNotificationsProcessorProtocol{
    
    
    func processNotification(userInfo: [AnyHashable : Any]){
        
        //if is a body notification - Notify: do nothing
        
        let genericNotification = parseStringNotification(content: userInfo)
        
        notificationInfo.messageID = (userInfo["gcm.message_id"] as! String)
        notificationInfo.type = genericNotification.type
        notificationInfo.trustID = KeychainWrapper.standard.string(forKey: "trustID")
        notificationInfo.bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken")
        
        let genericStringNotification = parseStringNotification(content: userInfo)
        notificationInfo.type = genericStringNotification.type
        switch genericStringNotification.type {
        case "dialog", "banner":
            let dialogNotification = parseDialog(content: genericStringNotification)
            notificationInfo.dialogNotification = dialogNotification
            router?.presentDialog(content: notificationInfo)
        case "video":
            let videoNotification = parseVideo(content: genericStringNotification)
            notificationInfo.videoNotification = videoNotification
            interactor?.downloadVideo(data: notificationInfo)
            //lottie
        default:
            print("error: must specify a notification type")
        }
    }
}


extension PushNotificationsProcessor: PushNotificationsInteractorOutputProtocol{
    func onReceptionConfirmationSuccess(userInfo: [AnyHashable : Any]) {
        processNotification(userInfo: userInfo)
    }
    
    func onCallbackSuccess() {
        //
    }
    
    func onCallbackFailure() {
        //
    }
    
    func onDownloadVideoSuccess(with url: URL) {
        //parar lottie
        self.notificationInfo.videoNotification?.videoUrl = url.absoluteString
        self.router?.presentVideo(content: self.notificationInfo)
    }
    
    func onDownloadVideoFailure() {
        //
    }
    
    
}
