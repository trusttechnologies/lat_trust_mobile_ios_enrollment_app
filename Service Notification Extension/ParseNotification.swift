//
//  ParseNotification.swift
//  Service Notification Extension
//
//  Created by Kevin Torres on 06-11-19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit
import Foundation

func parseNotification(content: [AnyHashable: Any]) -> GenericNotification {
    
    //take the notification content and convert it to data
    guard let jsonData = try? JSONSerialization.data(withJSONObject: content["data"], options: .prettyPrinted)
        else {
            print("Parsing notification error: Review your JSON structure")
            return GenericNotification()
    }
    
    //decode the notification with the structure of a generic notification
    let jsonDecoder = JSONDecoder()
    guard let notDialog = try? jsonDecoder.decode(GenericNotification.self, from: jsonData) else {
        print("Parsing notification error: Review your JSON structure")
        return GenericNotification() }
    
    return notDialog
}

func parseLegacyDialog(content: [AnyHashable: Any]) -> DialogLegacy {
    
    //take the notification content and convert it to data
    guard let jsonData = try? JSONSerialization.data(withJSONObject: content["data"], options: .prettyPrinted)
        else {
            print("Parsing notification error: Review your JSON structure")
            return DialogLegacy(type: "", typeDialog: "", body: "", title: "", isPay: "", buttonText: "", urlAction: "", cancelable: "")
    }
    
    //decode the notification with the structure of a generic notification
    let jsonDecoder = JSONDecoder()
    guard let notDialog = try? jsonDecoder.decode(DialogLegacy.self, from: jsonData) else {
        print("Parsing notification error: Review your JSON structure")
        return DialogLegacy(type: "", typeDialog: "", body: "", title: "", isPay: "", buttonText: "", urlAction: "", cancelable: "") }
    
    return notDialog
}

func parseLegacyVideo(content: [AnyHashable: Any]) -> VideoNotification {
    
    //take the notification content and convert it to data
    guard let jsonData = try? JSONSerialization.data(withJSONObject: content["data"], options: .prettyPrinted)
        else {
            print("Parsing notification error: Review your JSON structure")
            return VideoNotification(videoUrl: "", minPlayTime: "0.0", isPersistent: false, buttons: [])
    }
    
    //decode the notification with the structure of a generic notification
    let jsonDecoder = JSONDecoder()
    guard let notDialog = try? jsonDecoder.decode(VideoLegacy.self, from: jsonData) else {
        print("Parsing notification error: Review your JSON structure")
        return VideoNotification(videoUrl: "", minPlayTime: "0.0", isPersistent: false, buttons: []) }
    
    let button = Button(type: "action", text: notDialog.buttonText, color: "#F25E60", action: notDialog.urlAction)
    
    return VideoNotification(videoUrl: notDialog.urlVideo, minPlayTime: notDialog.playTime, isPersistent: false, buttons: [button])
}

func parseStringNotification(content: [AnyHashable: Any]) -> GenericStringNotification {
    
    //take the notification content and convert it to data
    guard let jsonData = try? JSONSerialization.data(withJSONObject: content["data"], options: .prettyPrinted)
        else {
            print("Parsing notification error: Review your JSON structure")
            return GenericStringNotification()
    }
    
    //decode the notification with the structure of a generic notification
    let jsonDecoder = JSONDecoder()
    guard let notDialog = try? jsonDecoder.decode(GenericStringNotification.self, from: jsonData) else {
        print("Parsing notification error: Review your JSON structure")
        return GenericStringNotification() }
    
    return notDialog
}



func parseDialog(content: GenericStringNotification) -> NotificationDialog {
    
    print(content)
    let contentAsString = content.notificationDialog?.replacingOccurrences(of: "\'", with: "\"", options: .literal, range: nil)
    let replacingApos = contentAsString?.replacingOccurrences(of: "&apos;", with: "'", options: .literal, range: nil)
    print("--------Change structure with double quotes-----------")
    print(replacingApos)
    
    let jsonDecoder = JSONDecoder()
    let dialogNotification = try? jsonDecoder.decode(NotificationDialog.self, from: replacingApos!.data(using: .utf8)!)

    return dialogNotification ?? NotificationDialog(textBody: "", imageUrl: "", isPersistent: false, isCancelable: true, buttons: [])
}

func parseVideo(content: GenericStringNotification) -> VideoNotification {
    print(content)
    let contentAsString = content.notificationVideo?.replacingOccurrences(of: "\'", with: "\"", options: .literal, range: nil)
    let replacingApos = contentAsString?.replacingOccurrences(of: "&apos;", with: "'", options: .literal, range: nil)
    print("--------Change structure with double quotes-----------")
    print(replacingApos)

    let jsonDecoder = JSONDecoder()
    guard let videoNotification = try? jsonDecoder.decode(VideoNotification.self, from: replacingApos!.data(using: .utf8)!) else {
        return VideoNotification(videoUrl: "", minPlayTime: "0.0", isPersistent: false, buttons: [])
    }
    return VideoNotification(videoUrl: videoNotification.videoUrl, minPlayTime: videoNotification.minPlayTime, isPersistent: videoNotification.isPersistent, buttons: videoNotification.buttons)
}
