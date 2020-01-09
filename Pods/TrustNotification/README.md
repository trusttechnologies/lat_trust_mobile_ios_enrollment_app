

# Trust Technologies 
![image](https://avatars2.githubusercontent.com/u/42399326?s=200&v=4)  
  
   
# Description  

The Trust Notification Library allows you to send push notifications to your users quick and easy. Adopting this library, you can send different messages to multiple devices.

We support multiple sorts of messages grouped into four categories:

* **Body Notifications:** This is the simplest type of notification, is a simple push notification with a title and a one or two-lines body.

* **Dialog Notifications:** This message presents a title and a body just as the Body Notification but also has an image and buttons with possible actions for your users. All these actions dynamically set.

* **Banner Notifications:** This notification is just like Dialog Notification but with only one difference: there is no notification body,  just the image, and buttons.

* **Video Notifications:** This message shows a video with a protected view time. After the protected time, the user is allowed to close the notification but not before. This notification also has two actionable buttons.

The image below presents the all four notification types.

![](https://i.imgur.com/oUmhVcu.png)

## Multimedia Specifications

To get a good visualization of the multimedia content. The images and videos have to satisfy the following dimension constraints.

* **Dialog Notifications:** Image with 340x320 aspect ratio
* **Banner Notifications:** Image with 340x400 aspect ratio
* **Video Notifications:** Video with 320x515 aspect ratio
  
# Implementation  

## Adding the Pod

If you don’t have any pods, run the following command into the terminal at the project's location:

```
pod init 
```
The command generates a file called Podfile. Open this file and add the following lines to the Podfile:

``` Swift
source 'https://github.com/trusttechnologies/trustnotificationpodspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'NameApp' do
	...
	pod 'TrustNotification'
	...
end
```
Then again in the command line console, run:

```
pod install 
```

This will install the library code into your project.

## Linking with the firebase project 

The Trust Notification Service uses a Firebase project. Please contact us at app@trust.lat to configure a project for your app. We will send you a file ``` GoogleService-Info.plist  ```. Add this file to your project.

## Service Notification Extension

The Service Notification Extension handles the view of the notification outside the app. In the image below we have an example.

<img src="https://i.imgur.com/itaKP66.jpg" width="250" />

To support this content, add the Service Notification Extension to your project. To do this, add a new target to the project clicking on File ---> New ---> Target ...  ---> Notification Service Extension. The procedure is in the images below.

<img src="https://lh3.googleusercontent.com/J3huLEycnzlTDQgRX_alMyD2MEGxICPfupjQyuxIQZimAZyBpsZxjotLxyRJqm8aaKx9_Rnum2Y" width="650" />

<img src="https://lh3.googleusercontent.com/7VZq29G9oDubKPbtInzwGuDeti6dWgn806HiipuuZ7T68D9Lre_QeGPJKRUKeVASpg3A5kj2_wc" width="650" />

# Initialize  
    
In this initialization, we look to set the Push Notification Library as the manager of the notifications and to register the phone in the notifications service. To do this is necessary to add the following lines of code to the App Delegate file of the host project. 

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

Add the library images to project assets from this   
[link](https://github.com/trusttechnologies/lat_trust_mobile_ios_trust-notification_library/raw/master/Notification%20icons.zip)

It is important to mantein the name of the files.

## Notification Service Extension

Add this files in the Notification Service Extension, and in case of NotificationService.Swift replace the code included in the respective file, all this files in this [link](https://github.com/trusttechnologies/lat_trust_mobile_ios_trust-notification_library/raw/master/Extension%20Files.zip)  
  
# Capabilities  
  
For this library to work properly, it is necessary to enable this capabilities.

```
	Keychain sharing 
	
	Push Notification
```	
  
For more details about Keycahin sharing, see the following link in the permissions section
[https://github.com/trusttechnologies/lat_trust_mobile_ios_trust-identify_library](https://github.com/trusttechnologies/lat_trust_mobile_ios_trust-identify_library)

If you need any information or have question about how to integrate this library to your project contact us at app@trust.lat
