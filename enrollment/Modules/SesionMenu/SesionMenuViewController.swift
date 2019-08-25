//
//  SesionMenuViewController.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import MaterialComponents
import UIKit

class SesionMenuViewController: UIViewController {
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
    
    var presenter: SesionMenuPresenterProtocol?
}

// MARK: - View
extension SesionMenuViewController: SesionMenuViewProtocol {}

// MARK: - Buttons targets
extension SesionMenuViewController {
    @objc func onLoginButtonPressed(sender: UIButton) {
        presenter?.onLoginButtonPressed(from: self)
    }
}
