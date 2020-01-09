//
//  Extensions.swift
//  appNotifications
//
//  Created by Jesenia Salazar on 9/2/19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

// MARK: Load image from URL
extension UIImageView {
    
    /**
     Call this function to load an image from url to an image view.
     
     - Parameters:
     - url: Url which has the image
     
     ### Usage Example: ###
     ````
     imageView.load(url: url)
     ````
     */
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                print("----DATA-----")
                print(data)
                print("----DATA-----")
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        print(image)
                    }
                }
            }
        }
    }
}


/**
 Call this function to verify if the url is valid
 
 - Parameters:
 - urlString: Url as string, check if is null, and if can reach the url
 
 ### Usage Example: ###
 ````
 verifyUrl(urlString: imageUrl)
 ````
 */
func verifyUrl (urlString: String?) -> Bool {
    //Check for nil
    if let urlString = urlString {
        // create NSURL instance
        if let url = NSURL(string: urlString) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url as URL)
        }
    }
    return false
}

/**
 This function is called to parse the notification data and transfor that in a generic notification
 
 - Parameters:
 - content: This is the JSON data [AnyHashable: Any].
 
 For more information of the differents structures and content of the JSON from notifications see the structs documentation
 
 ### Usage Example: ###
 ````
 verifyUrl(urlString: imageUrl)
 ````
 */

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
    
    let contentAsString = content.notificationDialog?.replacingOccurrences(of: "\'", with: "\"", options: .literal, range: nil)
    //let replacingApos = contentAsString?.replacingOccurrences(of: "&apos;", with: "'", options: .literal, range: nil)
    
    let jsonDecoder = JSONDecoder()
    let dialogNotification = try? jsonDecoder.decode(NotificationDialog.self, from: contentAsString!.data(using: .utf8)!)

    return dialogNotification ?? NotificationDialog(textBody: "", imageUrl: "", isPersistent: false, isCancelable: true, buttons: [])
}

func parseVideo(content: GenericStringNotification) -> VideoNotification {
  
    let contentAsString = content.notificationVideo?.replacingOccurrences(of: "\'", with: "\"", options: .literal, range: nil)
    //let replacingApos = contentAsString?.replacingOccurrences(of: "&apos;", with: "'", options: .literal, range: nil)

    let jsonDecoder = JSONDecoder()
    guard let videoNotification = try? jsonDecoder.decode(VideoNotification.self, from: contentAsString!.data(using: .utf8)!) else {
        return VideoNotification(videoUrl: "", minPlayTime: "0.0", isPersistent: false, buttons: [])
    }
    return VideoNotification(videoUrl: videoNotification.videoUrl, minPlayTime: videoNotification.minPlayTime, isPersistent: videoNotification.isPersistent, buttons: videoNotification.buttons)
}
 
extension UIColor {
    
    /**
     Set default colors
     */
    @nonobjc class var whiteRipple: UIColor {
        return UIColor(white: 1.0, alpha: 0.12)
    }
    /**
     Set default colors
     */
    @nonobjc class var white: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    /**
     Set default colors
     */
    @nonobjc class var black: UIColor {
        return UIColor(white: 33.0 / 255.0, alpha: 1.0)
    }
    
    /**
     Convert a color from hexadecimal to UIColor
     */
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }

}

/**
 Set the different button types for the notification
 */
enum CustomButtonType {
    case whiteButton
    case coloredButton
}

/**
 Set the different button types for the notification
 */
enum MdcType {
    case text
    case outlined
    case contained
}

extension MDCButton {
    
    /**
     Set the button properties according to the type
     */
    func setupButtonWithType(color: String, type: CustomButtonType, mdcType: MdcType) {
        
        let colorSchema = MDCSemanticColorScheme()
        let buttonScheme = MDCButtonScheme()
        
        switch type {
        case .whiteButton:
            colorSchema.primaryColor = UIColor.init(hex: color) ?? UIColor.blue
            colorSchema.onPrimaryColor = .white
            colorSchema.backgroundColor = .white
            self.inkColor = UIColor.init(hex: color)?.withAlphaComponent(0.12)
        case .coloredButton:
            colorSchema.primaryColor = UIColor.init(hex: color) ?? UIColor.blue
            colorSchema.onPrimaryColor = .white
            self.inkColor = .whiteRipple
        }
        
        buttonScheme.colorScheme = colorSchema
        buttonScheme.cornerRadius = 8
        
        self.clipsToBounds = true
        
        switch mdcType {
        case .text:
            MDCTextButtonThemer.applyScheme(buttonScheme, to: self)
            
        case .outlined:
            MDCOutlinedButtonThemer.applyScheme(buttonScheme, to: self)
            
        case .contained:
            MDCContainedButtonThemer.applyScheme(buttonScheme, to: self)
        }
        self.isUppercaseTitle = true
    }
}

extension UIView {
    /**
     Set animation fade in applycable to a visual object
     */
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    /**
     Set animation fade out applycable to a visual object
     */
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
}

func isIphoneXOrBigger() -> Bool {
    // 812.0 on iPhone X, XS.
    // 896.0 on iPhone XS Max, XR.
    return UIScreen.main.bounds.height >= 812
}

// MARK: - Storyboardable
protocol Storyboardable: AnyObject {
    static var defaultStoryboardName: String { get }
}

extension Storyboardable where Self: UIViewController {
    static var defaultStoryboardName: String {
        let selfName = String(describing: self)
        return selfName.replacingOccurrences(of: "ViewController", with: "")
    }
    
    static func storyboardViewController(bundle: Bundle? = nil) -> Self {
        let storyboard = UIStoryboard(name: defaultStoryboardName, bundle: bundle)
        
        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Could not instantiate initial storyboard with name: \(defaultStoryboardName)")
        }
        
        return vc
    }
}

extension UIViewController: Storyboardable { }

func getTopViewController() -> UIViewController{
    var topController = UIApplication.shared.keyWindow?.rootViewController
    while let presentedViewController = topController?.presentedViewController {
        topController = presentedViewController
    }
    return topController!
}
