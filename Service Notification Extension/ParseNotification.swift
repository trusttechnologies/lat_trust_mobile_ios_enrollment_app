//
//  ParseNotification.swift
//  Service Notification Extension
//
//  Created by Kevin Torres on 06-11-19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import Foundation
import UIKit

// MARK: -Parse Generic Notification

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

//MARK: -Parse Dialog
func parseDialog(content: GenericNotification) -> NotificationDialog {
    
    print(content)
    let contentAsString = content.notificationDialog?.replacingOccurrences(of: "\'", with: "\"", options: .literal, range: nil)
    print("--------Change structure with double quotes-----------")
    print(contentAsString)
    
    let jsonDecoder = JSONDecoder()
    let dialogNotification = try! jsonDecoder.decode(NotificationDialog.self, from: contentAsString!.data(using: .utf8)!)

    return dialogNotification
}

//MARK: -PARSE VIDEO
func parseVideo(content: GenericNotification) -> VideoNotification {
    print(content)
    let contentAsString = content.notificationVideo?.replacingOccurrences(of: "\'", with: "\"", options: .literal, range: nil)
    print("--------Change structure with double quotes-----------")
    print(contentAsString)

    let jsonDecoder = JSONDecoder()
    let videoNotification = try! jsonDecoder.decode(VideoNotification.self, from: contentAsString!.data(using: .utf8)!)

    return videoNotification
}
