//
//  ProcessNotification.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 06-01-20.
//  Copyright © 2020 Trust. All rights reserved.
//

import Foundation

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

        let dialogVC = DialogRouter.createModule()
        dialogVC.loadView()
        notificationInfo.type = "dialog"
        notificationInfo.dialogNotification = content
        dialogVC.modalPresentationStyle = .overCurrentContext
        dialogVC.data = notificationInfo
        dialogVC.fillDialog()
        
        
        let topMostViewController = getTopViewController()
        let window = UIApplication.shared.keyWindow

        
        if topMostViewController is DialogViewController {
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(dialogVC, animated: false)
            })
        }
        else if topMostViewController is VideoViewController{
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(dialogVC, animated: false)
            })
        }else if topMostViewController is DialogLegacyViewController{
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(dialogVC, animated: false)
            })
        }
        else{
            topMostViewController.present(dialogVC, animated: false)
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
        notificationInfo.videoNotification = content
        
        let videoVC = VideoRouter.createModule()
        videoVC.modalPresentationStyle = .overCurrentContext
        videoVC.loadView()
        videoVC.data = notificationInfo
        videoVC.fillVideo()
        
        
        
        let topMostViewController = getTopViewController()
        let window = UIApplication.shared.keyWindow
        
        if topMostViewController is DialogViewController {
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(videoVC, animated: false)
            })
        }
        else if topMostViewController is VideoViewController{
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(videoVC, animated: false)
            })
        }else if topMostViewController is DialogLegacyViewController{
            topMostViewController.dismiss(animated: true, completion: {
                let presentedViewController = window?.rootViewController?.presentedViewController
                presentedViewController?.present(videoVC, animated: false)
            })
        }
        else{
            topMostViewController.present(videoVC, animated: false)
        }
        
        window?.makeKeyAndVisible()
    }
    
    func presentLegacyDialog(){
        let dialogLegacyVC = DialogLegacyRouter.createModule()
        dialogLegacyVC.data = notificationInfo
        dialogLegacyVC.modalPresentationStyle = .overCurrentContext
        
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

}

extension PushNotifications{
    func processNotification(userInfo: [AnyHashable : Any]){
        
        //if is a body notification - Notify: do nothing
        
        let genericNotification = parseStringNotification(content: userInfo)
    
        notificationInfo.messageID = (userInfo["gcm.message_id"] as! String)
        notificationInfo.type = genericNotification.type
        
        
        if(genericNotification.typeDialog != nil){
            switch genericNotification.typeDialog {
            case "video":
                //parse legacy video
                let video = parseLegacyVideo(content: userInfo)
                presentVideo(content: video)
            default:
                presentLegacyDialog()
            }
            
        }else{
            let genericStringNotification = parseStringNotification(content: userInfo)
            notificationInfo.type = genericStringNotification.type
            switch genericStringNotification.type {
            case "dialog", "banner":
                let dialogNotification = parseDialog(content: genericStringNotification)
                presentDialog(content: dialogNotification)
            case "video":
                let videoNotification = parseVideo(content: genericStringNotification)
                presentVideo(content: videoNotification)
            default:
                print("error: must specify a notification type")
            }
        }
    }
}

