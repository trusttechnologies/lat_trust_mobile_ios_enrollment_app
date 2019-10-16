//
//  VideoViewController.swift
//  appNotifications
//
//  Created by Jesenia Salazar on 9/5/19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MaterialComponents
import MediaPlayer
import AudioToolbox

/// This is a class created for handling video notifications in Project

class VideoViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!{
        didSet{
            activityIndicator.isHidden = true
        }
    }
    
    /**
     Notification area
     */
    @IBOutlet weak var dialogView: UIView!
    
    
    /**
     Flag for handling the activation o deactivation of the video audio
     */
    var flagAudio: Bool = false
    
    
    /**
     Button on the left, for activate o deactivate the video audio
     */
    @IBOutlet weak var audioButton: UIButton!{
        didSet{
            
            let bundle = Bundle(for: VideoViewController.self)
            let origImage = UIImage(named: "audio_enabled_icon", in: bundle, compatibleWith: nil)
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            audioButton.setImage(tintedImage, for: .normal)
            audioButton.tintColor = .white
        }
    }
    
    /**
     Button on the left, for activate o deactivate the video audio
     */
    @IBAction func audioButton(_ sender: Any) {
        flagAudio = !flagAudio
    }
    
    /**
     Contains the close button and the remaining seconds label
     */
    @IBOutlet weak var closeView: UIView!{
        didSet{
            closeView.layer.cornerRadius = 18.0
        }
    }
    
    /**
     Close button, inactive for the first x seconds,  where x is defined by the notification sender
     */
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            let bundle = Bundle(for: VideoViewController.self)
            //let iconTest = UIImage(systemName: "stop")
            let buttonImage = UIImage(named: "close_icon", in: bundle, compatibleWith: nil)
            closeButton.setImage(buttonImage, for: .normal)
            closeButton.isEnabled = false
            flagAudio = false
        }
    }
    
    /**
     close button, handle the pressing action
     */
    @IBAction func closeButton(_ sender: Any) {
        flagAudio = true
        self.dismiss(animated: true)
    }
    
    /**
     Is a label that shows the remaining seconds for the close button to activate
     */
    @IBOutlet weak var remainSecLabel: UILabel!
    
    /**
     Is the video playing area
     */
    
    @IBOutlet weak var videoView: UIView!{
        didSet{
            videoView.clipsToBounds = true
        }
    }
    
    /**
     Url for action the the right button
     */
    var urlRightButton: String?
    /**
     Url for action the the left button
     */
    var urlLeftButton: String?
    
    
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
     This function is call in case that you have a video notification with two buttons, and the left button is pressed.
     */
    
    @objc func onLeftButtonPressed(sender: UIButton) {
        if let url = URL(string: urlLeftButton!) {
            UIApplication.shared.open(url , options: [:], completionHandler: nil)

        }
    }
    
    /**
     This function is call in case that you have a video notification with one or two buttons, and the right (or only) button is pressed.
     */
    
    @objc func onRightButtonPressed(sender: UIButton) {
        if let url = URL(string: urlRightButton!) {
            UIApplication.shared.open(url , options: [:], completionHandler: nil)
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
     videoVC.fillVideo(content: genericNotification)
     ````
     */
    
    func fillVideo(content: GenericNotification) {
        
        let aspectRatioConstraint = NSLayoutConstraint(item: self.videoView,attribute: .height,relatedBy: .equal,toItem: self.videoView,attribute: .width, multiplier: (500.0 / 320.0),constant: 0)
        let widthConstraint = NSLayoutConstraint(item: self.videoView,attribute: .height,relatedBy: .equal,toItem: self.videoView,attribute: .width, multiplier: (500.0 / 320.0),constant: 0)
        self.videoView.addConstraint(widthConstraint)
        self.videoView.addConstraint(aspectRatioConstraint)
        
        //self.videoView.frame.size.width
        //Set video
        if(verifyUrl(urlString: content.notificationVideo?.videoUrl)){
            
            remainSecLabel.isHidden = true
            activityIndicator.isHidden = false
            
            let videoURL = URL(string: content.notificationVideo!.videoUrl)
            let player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)
            let controller = AVPlayerViewController()
            let minPlayTime = content.notificationVideo?.minPlayTime ?? 0.00
            
            controller.player = player
            playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: (515.0/320.0) * (UIScreen.main.bounds.width))
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            videoView.layer.addSublayer(playerLayer)
            player.play()
            
            let interval = CMTime(seconds: 0.05,
                                  preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using:
                { (progressTime) in
                    
                    let seconds = CMTimeGetSeconds(progressTime)
                    let remaining = round(Double(minPlayTime) - seconds)
                    if(player.status == .readyToPlay ){
                        player.play()
                        self.activityIndicator.isHidden = true
                    }
                    player.isMuted = self.flagAudio
                    if(player.isMuted){
                        let bundle = Bundle(for: VideoViewController.self)
                        let origImage = UIImage(named: "audio_disabled_icon", in: bundle, compatibleWith: nil)
                        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                        self.audioButton.setImage(tintedImage, for: .normal)
                        self.audioButton.tintColor = .white
                    }else{
                        let bundle = Bundle(for: VideoViewController.self)
                        let origImage = UIImage(named: "audio_enabled_icon", in: bundle, compatibleWith: nil)
                        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                        self.audioButton.setImage(tintedImage, for: .normal)
                        self.audioButton.tintColor = .white
                    }
                    //lets move the slider thumb
                    if(seconds.isLess(than: Double(minPlayTime))){
                        self.remainSecLabel.text = "Quedan \(remaining) segundos"
                        self.remainSecLabel.isHidden = false
                        self.closeButton.isEnabled = false
                    }else{
                        self.remainSecLabel.isHidden = true
                        self.closeButton.isEnabled = true
                        self.closeView.fadeOut()
                        
                    }
            })
            
        }else{
            print("ERROR: URL DEL VIDEO NO VALIDA")
            
        }
        
        let buttons = content.notificationVideo?.buttons
        let buttonCounter = buttons?.count
        
        
        if(buttonCounter == 1){
    
            buttonL.isHidden = true
            //buttonL.isEnabled = false
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
    }
}
