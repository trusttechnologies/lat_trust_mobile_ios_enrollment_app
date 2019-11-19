

# Trust Technologies 
![image](https://avatars2.githubusercontent.com/u/42399326?s=200&v=4)  
  
   
# Description  
Trust notification allows you to send notifications quickly and easily, to meet the need to send notifications to multiple devices  


There are different types of notifications, dialogues and videos.
Videos needed a dimension of 320x515 content
The dialogues are divided into two:
* Images with text, for the image a ratio of 340x320 is required
* Banners (images without text), a ratio of 340x400 is required

These dimensions are used to keep one provided with the content
  
# Implementation  
If you don't have pods, run the following command from the terminal at the address where the project is located:
```
pod init 
```
Open Podfile and add: 
``` Swift
source 'https://github.com/trusttechnologies/trustnotificationpodspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'NameApp' do
	...
	pod 'TrustNotification'
	...
end
```
Then in the terminal run:
```
pod install 
```
Add file: ``` GoogleService-Info.plist  ```

Add new target to proyect
	 File ---> New ---> Target ...  ---> Notification Service Extension
	 As shown in the images
  ![enter image description here](https://lh3.googleusercontent.com/J3huLEycnzlTDQgRX_alMyD2MEGxICPfupjQyuxIQZimAZyBpsZxjotLxyRJqm8aaKx9_Rnum2Y "Add Target")

![enter image description here](https://lh3.googleusercontent.com/7VZq29G9oDubKPbtInzwGuDeti6dWgn806HiipuuZ7T68D9Lre_QeGPJKRUKeVASpg3A5kj2_wc "Select extension")
# Initialize  
    
This initiation establishes by default that automatic audits are not initiated  

```Swift
import TrustNotification

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	let notifications = PushNotifications(
			clientId: "example890348h02758a5f8bee4ba2d7880a48d0581e9efb", 
			clientSecret: "example8015437e7a963dacaa778961f647aa37f6730bd", 
			serviceName: "defaultServiceName", 
			accesGroup: "A2D9N3HN.trustID.example")

}

extension  AppDelegate{

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		...
		notifications.firebaseConfig(application: application)
		notifications.registerForRemoteNotifications()
		notifications.registerCustomNotificationCategory()
		...

		return true

	}
}
```

```Swift
func applicationDidBecomeActive(_ application: UIApplication) {
	...
	notifications.clearBadgeNumber()
	...
}
```

Add this files in Notification Service Extension 

DialogNotificationsStructs.siwft
```Swift
import Foundation

struct GenericNotification: Codable {
    
    var type: String!
    
    var notificationVideo: String?
    
    var notificationDialog: String?
    
    var notificationBody: BodyNotification?
    
}

struct NotificationDialog: Codable {
    
    var textBody: String
   
    var imageUrl: String
    
    var isPersistent: Bool
    
    var isCancelable: Bool
    
    var buttons: [Button]?
    
    enum CodingKeys: String, CodingKey {
        case buttons
        case imageUrl = "image_url"
        case isPersistent = "isPersistent"
        case isCancelable = "isCancelable"
        case textBody = "text_body"
    }
}

struct VideoNotification: Codable {
    
    var videoUrl: String
    
    var minPlayTime: Float
    
    var isPersistent: Bool
    
    var buttons: [Button]
    
    enum CodingKeys: String, CodingKey {
        case buttons
        case videoUrl = "video_url"
        case minPlayTime = "min_play_time"
        case isPersistent = "isPersistent"
        
    }
}

struct BodyNotification: Codable {
    var textTitle: String
    var textBody: String
    var imageUrl: String
    var buttons: [Button]
    
    enum CodingKeys: String, CodingKey {
        case buttons
        case textTitle = "text_title"
        case textBody = "text_body"
        case imageUrl = "image_url"
        
    }
}

struct Button: Codable {
    var type: String
    var text: String
    var color: String
    var action: String
}

```

ParseNotifications.swift
```Swift
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

```
Replace content of NotificationService.swift
```Swift
import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
        var bestAttemptContent: UNMutableNotificationContent?
        
        var downloadTask: URLSessionDownloadTask?
    
        var url:String?
        
        override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
            self.contentHandler = contentHandler
            bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
            
            let genericNotification = parseNotification(content: request.content.userInfo)
            switch genericNotification.type {
                case "notificationBody":
                    url = genericNotification.notificationBody?.imageUrl
                case "notificationDialog":
                    let dialogNotification = parseDialog(content: genericNotification)
                    url = dialogNotification.imageUrl
                case "notificationVideo":
                    let videoNotification = parseVideo(content: genericNotification)
                    url = videoNotification.videoUrl
                default:
                    print("error: must specify a notification type")
            }
                                        
    
            if let urlString = url, let fileUrl = URL(string: urlString) {
                // Download the attachment
                URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                    if let location = location {
                    // Move temporary file to remove .tmp extension
                        let tmpDirectory = NSTemporaryDirectory()
                        let tmpFile = "file://".appending(tmpDirectory).appending(fileUrl.lastPathComponent)
                        let tmpUrl = URL(string: tmpFile)!
                        try! FileManager.default.moveItem(at: location, to: tmpUrl)

                        // Add the attachment to the notification content
                        if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
                            self.bestAttemptContent?.attachments = [attachment]
                        }
                    }
                    // Serve the notification content
                    self.contentHandler!(self.bestAttemptContent!)
                }.resume()
            }
                             
        }
        
        override func serviceExtensionTimeWillExpire() {
            // Called just before the extension will be terminated by the system.
            // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
            if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
                contentHandler(bestAttemptContent)
            }
        }

}

```
Add images to project assets.  
[url download images](https://github.com/trusttechnologies/lat_trust_mobile_ios_trust-notification_library/raw/master/Notification%20icons.zip)

Call images with these names:
```
audio_disabled_icon
audio_enabled_icon
close_icon
```
# GoogleService-Info.plist file
    
To obtain this firebase file, contact the development team at app@trust.lat
Once the file is received, add to the project directory
  
  
# Permissions  
  
For the correct use of this library, it is necessary to grant the application overwriting permission

Enable capabilities: 
```
	Keychain sharing 
	
	Push Notification
```	
  
For more details about Keycahin sharing, see the following link in the permissions section
[https://github.com/trusttechnologies/lat_trust_mobile_ios_trust-identify_library](https://github.com/trusttechnologies/lat_trust_mobile_ios_trust-identify_library)
