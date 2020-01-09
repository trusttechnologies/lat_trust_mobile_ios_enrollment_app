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
    var processNotificationInteractor: ProcessNotificationInteractorProtocol? = ProcessNotificationInteractor()
    
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
        processNotificationInteractor?.interactorOutput = self
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
