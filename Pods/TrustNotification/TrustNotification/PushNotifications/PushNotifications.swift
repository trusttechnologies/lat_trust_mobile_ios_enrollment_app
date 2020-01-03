//
//  PushNotifications.swift
//  appNotifications
//
//  Created by Cristian Parra on 27-08-19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import Foundation
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import TrustDeviceInfo


/// This is a class created for handling notifications in general in the project
public class PushNotifications: NSObject {
    
    
    public var clientId: String
    public var clientSecret: String
    public var serviceName: String
    public var accesGroup: String
    
    var notificationInfo: NotificationInfo = NotificationInfo()
    
    public init(clientId:String, clientSecret:String, serviceName:String, accesGroup:String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.serviceName = serviceName
        self.accesGroup = accesGroup
    }
    
    public func firebaseConfig(application: UIApplication) {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        // Set the messaging delegate
        Messaging.messaging().delegate = self
    }
    
    
    public func registerForRemoteNotifications(){
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    
    public func clearBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}


//MARK: Messaging Delegate
extension PushNotifications: MessagingDelegate{
    
    /**
     This function monitors token refresh and register the firebase token in the trust service and receive the trustID
     this function does not need to be called
     */
    
    // MARK:  Monitor token refresh
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        Identify.shared.trustDeviceInfoDelegate = self
        Identify.shared.set(serviceName: serviceName, accessGroup: accesGroup)
        Identify.shared.createClientCredentials(clientID: clientId, clientSecret: clientSecret)
        Identify.shared.enable()
        guard let bundle = Bundle.main.bundleIdentifier else{
            print("Bundle ID Error")
            return
        }
        Identify.shared.registerFirebaseToken(firebaseToken: fcmToken, bundleID: bundle)
        
    }
    
    // MARK: Mapping your APNs token and registration token
    public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        //print("Received data message: \(remoteMessage.appData)")
    }
}


//MARK: TrustID Handling
extension PushNotifications: TrustDeviceInfoDelegate{
    public func onClientCredentialsSaved(savedClientCredentials: ClientCredentials) {
        guard let tokenType = savedClientCredentials.tokenType,
            let accessToken = savedClientCredentials.accessToken else { return }
        notificationInfo.bearerToken = "\(tokenType) \(accessToken)"
        KeychainWrapper.standard.set("\(tokenType) \(accessToken)", forKey: "bearerToken")
    }
    
    public func onTrustIDSaved(savedTrustID: String) {
        notificationInfo.trustID = savedTrustID
    }
    
    public func onRegisterFirebaseTokenSuccess(responseData: RegisterFirebaseTokenResponse) {
        print("Registro exitoso en el servicio de notificaciones \n\(responseData)\n")
        
    }
    
    public func onSendDeviceInfoResponse(status: ResponseStatus) {
        //TODO:
    }
}

//MARK: UserNotifications Handling
//extension PushNotifications: UNUserNotificationCenterDelegate{
//    
//    /**
//     This function is executed when a notification is received in the foreground. This function is not called by the developer.
//     
//     When a notification is received, parse the data and with that object, call the function to present the notification according to the content (video, dialog, banner)
//     */
//    
//    // MARK: Foreground Notification
//    public func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                        willPresent notification: UNNotification,
//                                        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        processNotification(userInfo: notification.request.content.userInfo)
//        
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        Messaging.messaging().appDidReceiveMessage(notification.request.content.userInfo)
//        
//        completionHandler([.alert, .badge, .sound])
//    }
//    
//    
//    /**
//     This function is executed when a notification is received in the background. This function is not called by the developer.
//     
//     When a notification is received, parse the data and with that object, call the function to present the notification according to the content (video, dialog, banner)
//     */
//    
//    // MARK: Background Notification
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            
//            switch response.actionIdentifier {
//            case "accept":
//                guard let stringUrl = response.notification.request.content.userInfo["url-scheme"] as? String else {
//                    print("Error parsing the url")
//                    return
//                }
//                
//                guard let url = URL(string: stringUrl) else {
//                    print("Error parsing the url")
//                    return
//                }
//                
//                if(verifyUrl(urlString: stringUrl)){
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }else{
//                    print("Invalid URL")
//                }
//                UIApplication.shared.applicationIconBadgeNumber = 0
//            case "cancel":
//                UIApplication.shared.applicationIconBadgeNumber = 0
//            default:
//                print("Other Action")
//                self.processNotification(userInfo: response.notification.request.content.userInfo)
//                
//            }
//            
//            completionHandler()
//        }
//        
//    }
//}


extension PushNotifications{
    
    /**
     This function is called by the UNUserNotificationCenterDelegate functions (if receive notification in foreground or background).
     
     - Parameters:
     - content: This is a generic notification that can have any kind of notification data, but for this function in particular, it is required a notification dialog tipe, for more information see the GenericNotification struct documentation
     
     ### Usage Example: ###
     ````
     presentDialog(content: genericNotification)
     ````
     */
    
    func presentDialog(content: NotificationDialog){
        
//        let storyboard = UIStoryboard(name: "DialogView", bundle: nil)
//        guard let dialogVC = storyboard.instantiateViewController(withIdentifier: "DialogView") as? DialogViewController else{
//            return
//        }
        
        let dialogVC = DialogRouter.createModule()
        dialogVC.loadView()
        notificationInfo.type = "dialog"
        notificationInfo.dialogNotification = content
        
        var topController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        
        let window = UIApplication.shared.keyWindow
        
        dialogVC.modalPresentationStyle = .overCurrentContext
        dialogVC.data = notificationInfo
        dialogVC.fillDialog()

        if topController is DialogViewController {
           
            topController?.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(dialogVC, animated: true)
            })
            
        }
        else if topController is VideoViewController{
            topController?.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(dialogVC, animated: true)
            })
        }
        else{
            topController?.present(dialogVC, animated: true)
        }
        
        window?.makeKeyAndVisible()
    }
    
    /**
     This function is called by the UNUserNotificationCenterDelegate functions (if receive notification in foreground or background).
     
     - Parameters:
     - content: This is a generic notification that can have any kind of notification data, but for this function in particular, it is required a notification video tipe, for more information see the GenericNotification struct documentation
     
     ### Usage Example: ###
     ````
     presentVideo(content: genericNotification)
     ````
     */
    
    func presentVideo(content: VideoNotification){
        //To Do
        
        notificationInfo.type = "video"
        notificationInfo.videoNotification = content
        
        let videoVC = VideoRouter.createModule()
        videoVC.modalPresentationStyle = .overCurrentContext
        videoVC.loadView()
        videoVC.data = notificationInfo
        videoVC.fillVideo()
        
        
        
        var topController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
         
        let window = UIApplication.shared.keyWindow
        
        
        
        if topController is DialogViewController {
            
            topController?.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(videoVC, animated: true)
            })
            
        }
        else if topController is VideoViewController{
            topController?.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(videoVC, animated: true)
            })
        }
        else{
            topController?.present(videoVC, animated: true)
        }
        
        window?.makeKeyAndVisible()
    }
//    func presentBodyNotification(content: GenericNotification){
//        //To Do
//        print("aquí deberia ir un body")
//    }
}

extension PushNotifications{
    func processNotification(userInfo: [AnyHashable : Any]){
        
        //if is a body notification - Notify: do nothing
        notificationInfo.messageID = (userInfo["gcm.message_id"] as! String)
        print(userInfo)
        guard let data = userInfo["data"] else {
            return
        }
        
        let genericNotification = parseNotification(content: userInfo)
        
        if(genericNotification.typeDialog != nil){
            print("soy una noti antiguita")
            switch genericNotification.typeDialog {
            case "video":
                //parse legacy video
                print("video legacy")
                let video = parseLegacyVideo(content: userInfo)
                presentVideo(content: video)
            default:
                let storyboard = UIStoryboard(name: "DialogLegacy", bundle: nil)
                guard let dialogLegacyVC = storyboard.instantiateViewController(withIdentifier: "DialogLegacy") as? DialogLegacyViewController else{
                    return
                }
                
                var topController = UIApplication.shared.keyWindow?.rootViewController
                
                while let presentedViewController = topController?.presentedViewController {
                    topController = presentedViewController
                }
                
                let window = UIApplication.shared.keyWindow
                
                dialogLegacyVC.modalPresentationStyle = .overCurrentContext

                if topController is DialogViewController {
                   
                    topController?.dismiss(animated: true, completion: {
                        let presentedViewController = window?.rootViewController?.presentedViewController
                        presentedViewController?.present(dialogLegacyVC, animated: true)
                    })
                    
                }
                else if topController is VideoViewController{
                    topController?.dismiss(animated: true, completion: {
                        let presentedViewController = window?.rootViewController?.presentedViewController
                        presentedViewController?.present(dialogLegacyVC, animated: true)
                    })
                }
                else{
                    topController?.present(dialogLegacyVC, animated: true)
                }
                
                window?.makeKeyAndVisible()

            }
            
        }else if(genericNotification.notificationVideo == nil && genericNotification.notificationDialog == nil){
            let genericStringNotification = parseStringNotification(content: userInfo)
        
            switch genericStringNotification.type {
            case "dialog":
                let dialogNotification = parseDialog(content: genericStringNotification)
                presentDialog(content: dialogNotification)
            case "banner":
                let dialogNotification = parseDialog(content: genericStringNotification)
                presentDialog(content: dialogNotification)
            case "video":
                let videoNotification = parseVideo(content: genericStringNotification)
                presentVideo(content: videoNotification)
            default:
                print("error: must specify a notification type")
            }
        }else{
            switch genericNotification.type {

            case "dialog":
                presentDialog(content: genericNotification.notificationDialog ?? NotificationDialog(textBody: "", imageUrl: "", isPersistent: false, isCancelable: true, buttons: []))
            case "banner":
            presentDialog(content: genericNotification.notificationDialog ?? NotificationDialog(textBody: "", imageUrl: "", isPersistent: false, isCancelable: true, buttons: []))
            case "video":
                presentVideo(content: genericNotification.notificationVideo ?? VideoNotification(videoUrl: "", minPlayTime: "", isPersistent: false, buttons: []))
            default:
                print("error: must specify a notification type")
            }
        }
    }
}

