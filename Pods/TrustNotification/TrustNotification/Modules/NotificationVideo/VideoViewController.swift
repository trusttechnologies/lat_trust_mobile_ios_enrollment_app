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
    
    var presenter: VideoPresenterProtocol?
    var urlLeftButton: String?
    var urlRightButton: String?
    var data: NotificationInfo?
    var flagAudio: Bool = false
    
    var viewState: LoadingStatus = .loading {
        didSet {
            switch viewState {
            case .loaded:
                activityIndicator.stopAnimating()
            case .loading:
                activityIndicator.startAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /**
     Notification area
     */
    @IBOutlet weak var dialogView: UIView!{
        didSet{
            dialogView.layer.borderWidth = 1.0
            dialogView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
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
            audioButton.addTarget(
                self,
                action: #selector(onAudioButtonPressed(sender:)),
                for: .touchUpInside)
        }
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
            closeButton.addTarget(
                self,
                action: #selector(onCloseButtonPressed(sender:)),
                for: .touchUpInside)
        }
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
            let aspectRatioConstraint = NSLayoutConstraint(item: self.videoView,attribute: .height,relatedBy: .equal,toItem: self.videoView,attribute: .width, multiplier: (500.0 / 320.0),constant: 0)
            let widthConstraint = NSLayoutConstraint(item: self.videoView,attribute: .height,relatedBy: .equal,toItem: self.videoView,attribute: .width, multiplier: (500.0 / 320.0),constant: 0)
            self.videoView.addConstraint(widthConstraint)
            self.videoView.addConstraint(aspectRatioConstraint)
        }
    }
    
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
        presenter?.onActionButtonPressed(action: urlLeftButton!)
    }
    
    /**
     This function is call in case that you have a video notification with one or two buttons, and the right (or only) button is pressed.
     */
    
    @objc func onRightButtonPressed(sender: UIButton) {
        presenter?.onActionButtonPressed(action: urlRightButton!)
    }
    
    @objc func onAudioButtonPressed(sender: UIButton) {
        flagAudio = !flagAudio
    }
    
    @objc func onCloseButtonPressed(sender: UIButton) {
        flagAudio = false
        presenter?.onCloseButtonPressed()
    }
    
}

extension VideoViewController: VideoViewProtocol{
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
    
    func fillVideo() {
        setViewState(state: .loading)
        setVideo()
        setActionButtons(buttons: data?.videoNotification?.buttons ?? [])
        setViewState(state: .loaded)
    }
    
    func setViewState(state: LoadingStatus) {
        viewState = state
    }
    
    func setVideo() {
        //
        
        if(verifyUrl(urlString: data?.videoNotification?.videoUrl)){
            
            remainSecLabel.isHidden = true
            activityIndicator.isHidden = false
            setViewState(state: .loading)
            
            let videoURL = URL(string: data?.videoNotification?.videoUrl ?? "")
            let player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)
            let controller = AVPlayerViewController()
            let minPlayTime = (data?.videoNotification?.minPlayTime as! NSString).floatValue ?? 0.00
            
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
                        self.setViewState(state: .loaded)
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
    }

    
    func setActionButtons(buttons: [Button]) {
        let buttonCounter = buttons.count
        
        if(buttonCounter == 1){
            
            buttonL.isHidden = true
            buttonR.setTitle(buttons[0].text , for: .normal)
            buttonR.setupButtonWithType(color: buttons[0].color, type: .whiteButton, mdcType: .text)
            urlRightButton = buttons[0].action
        }
        
        if(buttonCounter == 2){
            
            buttonL.setTitle(buttons[1].text , for: .normal)
            buttonL.setupButtonWithType(color: buttons[1].color, type: .whiteButton, mdcType: .text)
            urlLeftButton = buttons[1].action
            buttonR.setTitle(buttons[0].text , for: .normal)
            buttonR.setupButtonWithType(color: buttons[0].color, type: .whiteButton, mdcType: .text)
            urlRightButton = buttons[0].action
            
        }
    }
    
    
}
