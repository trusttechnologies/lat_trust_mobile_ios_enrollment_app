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
    let environment = ["prod","test"]
    var actualEnvironment: String?
    
    @IBOutlet weak var loadingView: LottieView!
    @IBOutlet weak var loadingBackground: UIView!
    
    @IBOutlet weak var changeEnvironmentButton: UIButton! {
        didSet {
            changeEnvironmentButton.addTarget(self, action: #selector(onChangeEnvironmentButton(sender:)), for: .touchUpInside)
        }
    }
    
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
        let secondsToDelay = 0.4
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) { //Delay animation            
            let animation = Animation.named(self.filename)
            self.animationView.animation = animation
            self.animationView.contentMode = .scaleAspectFit
            self.animationView.play(fromProgress: 0,
                               toProgress: 1,
                               loopMode: LottieLoopMode.loop,
                               completion: { (finished) in
                                if finished {
                                    print("Animation Complete")
                                } else {
                                    print("Animation cancelled")
                                }
            })
            self.animationView.translatesAutoresizingMaskIntoConstraints = false
            self.loadingView.addSubview(self.animationView)
            
            self.loadingBackground.backgroundColor = .gray
            self.loadingView.backgroundColor = .gray
            
            NSLayoutConstraint.activate([
                self.animationView.heightAnchor.constraint(equalTo: self.loadingView.heightAnchor),
                self.animationView.widthAnchor.constraint(equalTo: self.loadingView.widthAnchor),
            ])
            
            self.activityIndicatorBackground.show()
            self.loadingBackground.show()
            self.view.bringSubviewToFront(self.loadingView)
            self.animationView.backgroundBehavior = .pauseAndRestore
        }
    }
    
    func stopActivityIndicator() {
        loadingBackground.hide()
        activityIndicator.stopAnimating()
        activityIndicatorBackground.hide()
    }
}

// MARK: - Buttons targets
extension SessionMenuViewController {
    @objc func onLoginButtonPressed(sender: UIButton) {
        presenter?.onLoginButtonPressed(from: self)
    }
    
    @objc func onChangeEnvironmentButton(sender: UIButton) {
        //OPEN SELECT AND PUT WEA

        
        print("Pressed")
        presenter?.changeEnvironment(environment: "test")
//        presenter?.changeEnvironment()
    }
    func createEnvironmenPicker() {
        let environmentPicker = UIPickerView()
        environmentPicker.delegate = self
    }
}

extension SessionMenuViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return environment.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return environment[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        actualEnvironment = environment[row]
    }
}
