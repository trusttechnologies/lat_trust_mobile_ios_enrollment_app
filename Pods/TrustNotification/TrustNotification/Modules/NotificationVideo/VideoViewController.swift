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
    var flagAudio: audioState = .enabled
    var videoManager: VideoManager = VideoManager()
    var videoURL: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    /**
     Notification area
     */
    @IBOutlet weak var dialogView: UIView!{
        didSet{
            dialogView.layer.cornerRadius = 5
            dialogView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            dialogView.layer.shadowRadius = 13
            dialogView.layer.shadowOpacity = 0.25
        }
    }
    
    /**
     Button on the left, for activate o deactivate the video audio
     */
    
    func setAudioImage(){
        let enabledImage = setImageForButtons(bundle: VideoViewController.self, imageName: "audio_enabled_icon")
        let disabledImage = setImageForButtons(bundle: VideoViewController.self, imageName: "audio_disabled_icon")
        
        switch flagAudio {
        case .enabled:
            audioButton.setImage(enabledImage, for: .normal)
        case .disabled:
            audioButton.setImage(disabledImage, for: .normal)
        }
        audioButton.tintColor = .white
    }
    
    @IBOutlet weak var audioButton: UIButton!{
        didSet{
            setAudioImage()
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
    
    @IBOutlet weak var replayButton: UIButton!{
        didSet{
            let buttonImage = setImageForButtons(bundle: VideoViewController.self, imageName: "reloadIcon")
            replayButton.setImage(buttonImage, for: .normal)
            replayButton.tintColor = .white
            replayButton.isEnabled = false
            replayButton.isHidden = true
            replayButton.addTarget(
                self,
                action: #selector(onReplayButtonPressed(sender:)),
                for: .touchUpInside)
        }
    }
    /**
     Close button, inactive for the first x seconds,  where x is defined by the notification sender
     */
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            let bundle = Bundle(for: VideoViewController.self)
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
    
    @IBOutlet weak var videoView: VideoView!{
        didSet{
            videoView.clipsToBounds = true
            videoView.layer.cornerRadius = 5
            videoView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBOutlet weak var buttonsStack: UIStackView!{
        didSet{
            buttonsStack.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    
    @IBOutlet weak var buttonsMargin: UIView!{
        didSet{
            buttonsMargin.layer.cornerRadius = 5
            buttonsMargin.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
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
        switch flagAudio {
        case .enabled:
            flagAudio = .disabled
        default:
            flagAudio = .enabled
        }
        setAudioImage()
    }
    
    @objc func onReplayButtonPressed(sender: UIButton) {
        videoManager.player?.seek(to: CMTime.zero)
        videoManager.player?.play()
        replayButton.isHidden = true
        replayButton.isEnabled = false
    }
    
    @objc func onCloseButtonPressed(sender: UIButton) {
        videoManager.player?.pause()
        videoManager.player?.replaceCurrentItem(with: nil)
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
        setVideo()
        setActionButtons(buttons: data?.videoNotification?.buttons ?? [])
    }
    
    @objc func playerDidFinishPlaying(){
        replayButton.isHidden = false
        replayButton.isEnabled = true
    }
    
    func setVideo() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        replayButton.isHidden = true
        remainSecLabel.isHidden = true
        remainSecLabel.adjustsFontForContentSizeCategory = true
        
        
        videoURL = URL(string: data?.videoNotification?.videoUrl ?? "")
//        let resolution = resolutionForLocalVideo(url: videoURL!)
//        print(resolution)
//        let aspectRatioConstraint = NSLayoutConstraint(item: self.videoView,attribute: .height,relatedBy: .equal,toItem: self.videoView,attribute: .width, multiplier: (resolution!.height / resolution!.width),constant: 0)//618x1024
//        self.videoView.addConstraint(aspectRatioConstraint)
        
        //videoManager.player = AVPlayer(url: videoURL!)
        //let playerLayer = AVPlayerLayer(player: videoManager.player)
        let minPlayTime = (data?.videoNotification?.minPlayTime as! NSString).floatValue
        
        
        videoView.playerLayer.frame = videoView.bounds
        videoView.playerLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        videoView.playerLayer.cornerRadius = 5
        
        if UIScreen.main.bounds.height >= 736{
            videoView.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill}
        else{
            videoView.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        }
        //videoView.layer.addSublayer(playerLayer)
        //player?.play()
        
        let interval = CMTime(seconds: 0.05,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        videoManager.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using:
            { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let remaining = Int(round(Double(minPlayTime) - seconds))
//                if(self.player?.status == .readyToPlay ){
//                    self.player?.play()
//                    //self.setViewState(state: .loaded)
//                }
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
    }
    
    
    func setActionButtons(buttons: [Button]) {
        let buttonCounter = buttons.count
        
        if buttonCounter == 0{
            buttonsStack.isHidden = true
            buttonL.isHidden = true
            buttonR.isHidden = true
        }
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
