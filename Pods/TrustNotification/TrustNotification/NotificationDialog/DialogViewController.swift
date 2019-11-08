//
//  DialogViewController.swift
//  appNotifications
//
//  Created by Jesenia Salazar on 9/2/19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import UIKit
import MediaPlayer
import MaterialComponents

/// This is a class created for handling banner and video notifications in Project

class DialogViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var screenArea: UIView!
    /**
     Notification area
     */
    @IBOutlet weak var dialogView: UIView!{
        didSet{
            dialogView.layer.cornerRadius = 4.0
            dialogView.clipsToBounds = true
            dialogView.layer.borderWidth = 1.0
            dialogView.layer.borderColor = UIColor.black.cgColor
            
        }
    }
    
    /**
     If persistence is true, this button controls the touching outside the notification area
     */
    @IBOutlet weak var persistenceButton: UIButton!
    
    /**
     If persistence is true, this button controls the touching outside the notification area
     */
    @IBAction func persistenceButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /**
     Close button, available if the notification is cancelable
     */
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            let bundle = Bundle(for: DialogViewController.self)
            let buttonImage = UIImage(named: "close_icon", in: bundle, compatibleWith: nil)
            closeButton.setImage(buttonImage, for: .normal)
        }
    }
    
    /**
     Close button, available if the notification is cancelable
     */
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    /**
     Image area of the notification
     */
    
    @IBOutlet weak var imageView: UIImageView!
    
    /**
     Container of the body of the notification, if the notification has no text, this container desapear from the view
     */
    @IBOutlet weak var labelStackView: UIStackView!
    
    /**
     Body of the notification
     */
    @IBOutlet weak var body: UILabel!
    
    /**
     Left margin for the body of the notification
     */
    @IBOutlet weak var leftMargin: UIView!
    
    @IBOutlet weak var upperMargin: UIView!
    @IBOutlet weak var lowerMargin: UIView!
    /**
     Right margin for the body of the notification
     */
    @IBOutlet weak var rightMargin: UIView!
    
    /**
     Url for action the the left button
     */
    var urlLeftButton: String?
    /**
     Url for action the the right button
     */
    var urlRightButton: String?
    
    /**
     Left button, in case that the notification has two buttons
     */
    @IBOutlet weak var buttonL: MDCButton!{
        didSet{
            buttonL.addTarget(
                self,
                action: #selector(onLeftButtonPressed(sender:)),
                for: .touchUpInside)
        }
    }
    
    /**
     Right button, in case that the notification has one or two buttons
     */
    @IBOutlet weak var buttonR: MDCButton!{
        didSet{
            buttonR.addTarget(
                self,
                action: #selector(onRightButtonPressed(sender:)),
                for: .touchUpInside)
        }
    }
    
    
    /**
     Call this function for set the notification background.
     - Parameters:
     - color : there are three options parameterized for background color
     - .SOLID : Gray solid color
     - .TRANSPARENT: Black color with 60% opacity
     - .NO_BACKGROUND: The notification is shown withouth any background and what is seen behind the notification is the screen of the application being used.
     
    
     ### Usage Example: ###
     ````
     videoVC.setBackground(color: .SOLID)
     ````
     */
    
    func setBackground(color: backgroundColor){
        switch color {
        case .SOLID:
            view.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.16, alpha:1)
        case .TRANSPARENT:
            view.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.16, alpha:0.6)
        case .NO_BACKGROUND:
            view.backgroundColor = UIColor.clear
        }
    }
    
    /**
     Call this function for set the notification content.
     - Parameters:
     - content : this is an object from class GenericNotification, this class contains the data parsed from the notification.
     
     
     ### Usage Example: ###
     ````
     dialogVC.fillDialog(content: genericNotification)
     ````
     */
    
    func fillDialog(content: NotificationDialog) {
            
            if(isIphoneXOrBigger()){
                dialogView.frame = CGRect(x:0, y: 0, width: 0.9 * screenArea.frame.width, height: 0.2 * screenArea.frame.height)
            }else{
                dialogView.frame = CGRect(x:0, y: 0, width: 0.9 * screenArea.frame.width, height: 0.2 * screenArea.frame.height)
            }
            
            //Set body label
            if(content.textBody != ""){
                body.text = content.textBody
                body.textAlignment = NSTextAlignment.center
                body.numberOfLines = 0
                body.lineBreakMode = .byWordWrapping
                body.sizeToFit()
                let aspectRatioConstraint = NSLayoutConstraint(item: self.imageView,attribute: .height,relatedBy: .equal,toItem: self.imageView,attribute: .width, multiplier: (320.0 / 340.0),constant: 0)
                self.imageView.addConstraint(aspectRatioConstraint)
            }else{
                body.isHidden = true
                leftMargin.isHidden = true
                rightMargin.isHidden = true
                upperMargin.isHidden = true
                lowerMargin.isHidden = true
                labelStackView.isHidden = true
                let aspectRatioConstraint = NSLayoutConstraint(item: self.imageView,attribute: .height,relatedBy: .equal,toItem: self.imageView,attribute: .width, multiplier: (400.0 / 340.0),constant: 0)
                self.imageView.addConstraint(aspectRatioConstraint)
            }
            
            //Set the dialog image
            if(verifyUrl(urlString: content.imageUrl)){
                let imageUrl = URL(string: content.imageUrl)!
                imageView.load(url: imageUrl)
                imageView.contentMode = .scaleAspectFill
            }else{
                imageView.isHidden = true
            }
            
            //Set the close button
            if(!(content.isCancelable ?? true)){
                closeButton.isEnabled = false
                closeButton.isHidden = true
            }else{
                closeButton.isEnabled = true
                closeButton.isHidden = false
            }
            
            //Set touching outside the dialog process
            if(!(content.isPersistent ?? false)){
                persistenceButton.isEnabled = true
                persistenceButton.isHidden = false
                setBackground(color: .NO_BACKGROUND)
            }else{
                persistenceButton.isEnabled = false
                persistenceButton.isHidden = true
                setBackground(color: .TRANSPARENT)
            }
            
            let buttons = content.buttons
            let buttonCounter = buttons!.count
            
            if(buttonCounter == 1){
                
                buttonL.isHidden = true
                buttonR.setTitle(buttons![0].text ?? "", for: .normal)
                buttonR.setupButtonWithType(color: buttons![0].color, type: .whiteButton, mdcType: .text)
                urlRightButton = buttons![0].action
            }
            
            if(buttonCounter == 2){
                
                buttonL.setTitle(buttons![1].text ?? "", for: .normal)
                buttonL.setupButtonWithType(color: buttons![1].color, type: .whiteButton, mdcType: .text)
                urlLeftButton = buttons![1].action
                buttonR.setTitle(buttons![0].text ?? "", for: .normal)
                buttonR.setupButtonWithType(color: buttons![0].color, type: .whiteButton, mdcType: .text)
                urlRightButton = buttons![0].action
                
            }
            
            print(content.buttons ?? "contentButtons")
    }
    
    /**
     This function is call in case that you have a video notification with two buttons, and the left button is pressed.
     */
    @objc func onLeftButtonPressed(sender: UIButton) {
        if let url = URL(string: urlLeftButton!) {
            UIApplication.shared.open(url , options: [:], completionHandler: nil)
            self.dismiss(animated: true)
        }
    }
    
    /**
     This function is call in case that you have a video notification with one or two buttons, and the right (or only) button is pressed.
     */
    @objc func onRightButtonPressed(sender: UIButton) {
        if let url = URL(string: urlRightButton!) {
            UIApplication.shared.open(url , options: [:], completionHandler: nil)
            self.dismiss(animated: true)
        }
    }
    
}
