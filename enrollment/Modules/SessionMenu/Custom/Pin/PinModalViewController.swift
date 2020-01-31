//
//  PinModalViewController.swift
//  enrollment
//
//  Created by Kevin Torres on 24-01-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit
import TrustDeviceInfo

class PinModalViewController: UIViewController {
    var viewController: UIViewController?
    
    @IBOutlet weak var insertedPin: UITextField! {
        didSet {
            insertedPin.keyboardType = .asciiCapableNumberPad
        }
    }
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.addTarget(self, action: #selector(onCancelButtonPressed(sender:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var checkPinButton: UIButton! {
        didSet {
            checkPinButton.addTarget(self, action: #selector(onCheckPinButton(sender:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var showActualEnvironmentButtonTest: UIButton! {
        didSet {
            showActualEnvironmentButtonTest.addTarget(self, action: #selector(onShowActualEnvironment(sender:)), for: .touchUpInside)

        }
    }
}

// MARK: - Target buttons
extension PinModalViewController {
    @objc func onCheckPinButton(sender: UIButton) {
        if insertedPin.text == "0303456" {
            let environmentVC = EnvironmentModalViewController.storyboardViewController()
            self.present(environmentVC, animated: true)
        } else {
            print("Incorrect PIN.")
        }

    }
    
    @objc func onCancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @objc func onShowActualEnvironment(sender: UIButton) {
        let actualEnvironment = Identify.shared.getCurrentEnvironment()
        print("Actual environment: \(actualEnvironment)")
    }
}

// MARK: - Life cycles
extension PinModalViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
