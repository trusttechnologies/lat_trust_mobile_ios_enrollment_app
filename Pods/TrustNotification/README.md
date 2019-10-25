
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
			clientId: "adcc11078bee4ba2d7880a48c4bed02758a5f5328276b08fa14493306f1e9efb", 
			clientSecret: "1f647aab37f4a7d7a0da408015437e7a963daca43da06a7789608c319c2930bd", 
			serviceName: "defaultServiceName", 
			accesGroup: "P896AB2AMC.trustID.appLib")

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

Add this function in class of Notification Service Extension 
```Swift
 func fileDonwload( urlString: String) -> Void {
	 guard let url = URL(string: urlString) else {
		// Cannot create a valid URL, return early.
		contentHandler(bestAttemptContent!)
		return
		}
                
	self.downloadTask = URLSession.shared.downloadTask(with: url) { (location, response, error) in
		if let location = location {
			let tmpDirectory = NSTemporaryDirectory()
            let tmpFile = "file://".appending(tmpDirectory).appending(url.lastPathComponent)
                        
            let tmpUrl = URL(string: tmpFile)!
            try! FileManager.default.moveItem(at: location, to: tmpUrl)
                        
	        if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
				self.bestAttemptContent?.attachments = [attachment]
            }
		}
                    
	    self.contentHandler!(self.bestAttemptContent!)
	}
                
	self.downloadTask?.resume()
}
```
            
```Swift            
func getURLpayload() -> String {
	var urlString:String?
    if let url = bestAttemptContent!.userInfo["data"] as? Dictionary<AnyHashable, Any> {
                    
		if let imageUrl = url["notificationBody"] as? Dictionary<AnyHashable, Any> {
                        
			urlString = imageUrl["image_url"] as? String
                        
            }
		else if let videoURL = url["notificationVideo"] as? Dictionary<AnyHashable, Any> {
                        
			urlString = videoURL["video_url"] as? String
                        
		}
        else if let imageUrl = url["notificationDialog"] as? Dictionary<AnyHashable, Any> {
                        
			urlString = imageUrl["image_url"] as? String
                        
		}
        else {
	        // Nothing to add to the push, return early.
            contentHandler(bestAttemptContent!)
        }
	}
    return urlString!
} 
```


```Swift            
func setTitleAndBody(){
                
	if let data = bestAttemptContent?.userInfo["data"] as? Dictionary<AnyHashable, Any>{
		if let type = data["notificationBody"] as? Dictionary<AnyHashable, Any>{
                        
			if let title = type["text_title"] as? String{
				bestAttemptContent?.title = title
			}
            if let body = type["text_body"] as? String{
	            bestAttemptContent?.body = body
            }
                        
		}
                        
        else if let type = data["notificationDialog"] as? Dictionary<AnyHashable, Any>{
			if let title = type["text_title"] as? String{
	            bestAttemptContent?.title = title
            }
                        
            if let body = type["text_body"] as? String{
	            bestAttemptContent?.body = body
            }
		}
                        
        else if let type = data["notificationVideo"] as? Dictionary<AnyHashable, Any>{
                        
	        if let title = type["text_title"] as? String{
	            bestAttemptContent?.title = title
            }
            if let body = type["text_body"] as? String{
	            bestAttemptContent?.body = body
            }
		}
	}
}
```

```Swift
class NotificationService: UNNotificationServiceExtension {
	var contentHandler: ((UNNotificationContent) -> Void)?
	var bestAttemptContent: UNMutableNotificationContent?

	var downloadTask: URLSessionDownloadTask?

	override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
		self.contentHandler = contentHandler

		bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

		if let bestAttemptContent = bestAttemptContent {

			//Modify the notification content here...

			//bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
			
			...
			setTitleAndBody()

			let urlString = getURLpayload()

			fileDonwload( urlString: urlString)
			...
		    //contentHandler(bestAttemptContent)_

		}

	}
	override func serviceExtensionTimeWillExpire() {

		//Called just before the extension will be terminated by the system._

		// Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used._

		if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {

			contentHandler(bestAttemptContent)

		}
	}
}
```
Add image package to project assets. 
link zip images 

audio_disabled_icon
audio_enabled_icon
close_icon
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
