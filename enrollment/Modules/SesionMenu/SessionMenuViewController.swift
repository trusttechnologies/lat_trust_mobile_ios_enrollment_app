//
//  SessionMenuViewController.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import MaterialComponents
import UIKit
import Lottie

class SessionMenuViewController: UIViewController {
    
    var animationView = AnimationView()
    let filename = "enrollmentLoading"
    
    @IBOutlet weak var loadingView: LottieView!
    
    @IBOutlet weak var loginButton: MDCButton! {
        didSet {
            loginButton.setupButtonWithType(type: .btnPrimary, mdcType: .contained)
    
            loginButton.addTarget(
                self,
                action: #selector(onLoginButtonPressed(sender:)),
                for: .touchUpInside
            )
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorBackground: UIView!
    
    var presenter: SessionMenuPresenterProtocol?
}

// MARK: - View
extension SessionMenuViewController: SessionMenuViewProtocol {
    func startActivityIndicator() {
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.loop,
                           completion: { (finished) in
                            if finished {
                                print("Animation Complete")
                            } else {
                                print("Animation cancelled")
                            }
        })
        animationView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: loadingView.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: loadingView.widthAnchor),
        ])
        
//        activityIndicator.startAnimating()
        activityIndicatorBackground.show()
        animationView.backgroundBehavior = .pauseAndRestore
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicatorBackground.hide()
    }
}

// MARK: - Buttons targets
extension SessionMenuViewController {
    @objc func onLoginButtonPressed(sender: UIButton) {
        presenter?.onLoginButtonPressed(from: self)
    }
}
