//
//  VideoManager.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 18-03-20.
//  Copyright © 2020 Trust. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import MaterialComponents
import MediaPlayer
import AudioToolbox

enum audioState{
    case enabled
    case disabled
}

protocol VideoManagerDelegate: AnyObject{
    func onStartPaused()
    func onStartSilent()
    func onSetReplay()
    func onTimeProtected()
    
   
}

class VideoManager{
    var flagAudio: audioState = .enabled
    var player: AVPlayer?
    let controller = AVPlayerViewController()
    var videoURL: URL?
    
    var notificationSpecificsDelegate: VideoManagerDelegate?
    
    func videoInit(){
        player = AVPlayer(url: videoURL!)
        controller.player = player
    }
    func setAudioState(state: audioState){
        flagAudio = state
    }
    
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerFail), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerTimeJumped), name: .AVPlayerItemTimeJumped, object: nil)

    }
    
    @objc func playerDidFinishPlaying(){notificationSpecificsDelegate!.onSetReplay()}
    @objc func playerFail(){}
    @objc func playerTimeJumped(){}
}
