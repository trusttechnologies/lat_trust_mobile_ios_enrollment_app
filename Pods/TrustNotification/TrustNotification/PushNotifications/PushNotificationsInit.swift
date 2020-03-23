//
//  PushNotificationsInit.swift
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

public class PushNotificationsInit: NSObject, PushNotificationsInitProtocol, UNUserNotificationCenterDelegate{
    
    var pushNotificationsProcessor: PushNotificationsProcessor?
    
    public var clientId: String = ""
    public var clientSecret: String = ""
    public var serviceName: String = ""
    public var accessGroup: String = ""
    
    public func initTrustNotifications(){
        
        let presenter: PushNotificationsProcessorProtocol & PushNotificationsInteractorOutputProtocol & UNUserNotificationCenterDelegate = PushNotificationsProcessor()
        var interactor: PushNotificationsInteractorProtocol & CallbackDataManagerOuputProtocol & VideoDownloadDataManagerOutputProtocol = PushNotificationsInteractor()
        let router = PushNotificationsInit()
        
        let callbackDataManager = CallbackDataManager()
        let videoDownloadDataManager = VideoDownloadDataManager()
        
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.interactorOutput = presenter
        interactor.callbackDataManager = callbackDataManager
        interactor.videoDownloadDataManager = videoDownloadDataManager
        
        callbackDataManager.managerOutput = interactor
        videoDownloadDataManager.managerOutput = interactor
        
        self.pushNotificationsProcessor = (presenter as! PushNotificationsProcessor)
    }
    
    /**
     This function is called by the UNUserNotificationCenterDelegate functions (if receive notification in foreground or background).
     
     - Parameters:
     - content: This is a generic notification that can have any kind of notification data, but for this function in particular, it is required a notification dialog tipe, for more information see the GenericNotification struct documentation
     
     ### Usage Example: ###
     ````
     presentDialog(content: genericNotification)
     ````
     */
    
    func presentDialog(content: NotificationInfo){

        if(verifyUrl(urlString: content.dialogNotification?.imageUrl)){
            let dialogVC = DialogRouter.createModule()
            dialogVC.loadView()
            dialogVC.modalPresentationStyle = .overCurrentContext
            dialogVC.data = content
            dialogVC.fillDialog()
            
            
            let topMostViewController = getTopViewController()
            let window = UIApplication.shared.keyWindow

            
            if topMostViewController is DialogViewController {
                topMostViewController.dismiss(animated: true, completion: {
                    let presentedViewController = window?.rootViewController?.presentedViewController
                    presentedViewController?.present(dialogVC, animated: true)
                })
            }
            else if topMostViewController is VideoViewController{
                topMostViewController.dismiss(animated: true, completion: {
                    let presentedViewController = window?.rootViewController?.presentedViewController
                    presentedViewController?.present(dialogVC, animated: true)
                })
            }
            else{
                topMostViewController.present(dialogVC, animated: true)
            }
            
            window?.makeKeyAndVisible()
        }
        else{
            pushNotificationsProcessor?.interactor?.onNotificationArrive(data: content, action: "", state: "_error", errorMessage: "image url unreachable")
        }
        
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
    
    func presentVideo(content: NotificationInfo){
        
        let videoVC = VideoRouter.createModule()
        videoVC.modalPresentationStyle = .overCurrentContext
        videoVC.loadView()
        videoVC.data = content
        videoVC.fillVideo()
        
        
        
        let topMostViewController = getTopViewController()
        let window = UIApplication.shared.keyWindow
        
        if topMostViewController is DialogViewController {
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(videoVC, animated: true)
            })
        }
        else if topMostViewController is VideoViewController{
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(videoVC, animated: true)
            })
        }
        else{
            topMostViewController.present(videoVC, animated: true)
        }
        
        window?.makeKeyAndVisible()
    }
}



//MARK: Initial Settings

extension PushNotificationsInit{
    //MARK: Initial Settings
    public func firebaseConfig(application: UIApplication) {
        // Use Firebase library to configure APIs
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        // Set the messaging delegate
        Messaging.messaging().delegate = self
    }
    
    
    public func registerForRemoteNotifications(){
        UNUserNotificationCenter.current().delegate = self.pushNotificationsProcessor
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
extension PushNotificationsInit: MessagingDelegate{
    
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
        Identify.shared.set(serviceName: serviceName, accessGroup: accessGroup)
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
extension PushNotificationsInit: TrustDeviceInfoDelegate{
    public func onClientCredentialsSaved(savedClientCredentials: ClientCredentials) {
        guard let tokenType = savedClientCredentials.tokenType,
            let accessToken = savedClientCredentials.accessToken else { return }

        KeychainWrapper.standard.set("\(tokenType) \(accessToken)", forKey: "bearerToken")
    }
    
    public func onTrustIDSaved(savedTrustID: String) {
        KeychainWrapper.standard.set("\(savedTrustID)", forKey: "trustID")
    }
    
    public func onRegisterFirebaseTokenSuccess(responseData: RegisterFirebaseTokenResponse) {
        print("Registro exitoso en el servicio de notificaciones \n\(responseData)\n")
        
    }
    
    public func onSendDeviceInfoResponse(status: ResponseStatus) {
        //TODO:
    }
}
