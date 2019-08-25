//
//  WelcomeScreenViewController.swift
//  enrollment
//
//  Created by Kevin Torres on 8/24/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import MaterialComponents
import UIKit

// MARK: WelcomeScreenDataSource
protocol WelcomeScreenDataSource {
    var welcomeMessage: String? {get}
    var username: String? {get}
}

class WelcomeScreenViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var continueButton: MDCButton! {
        didSet {
            let buttonScheme = MDCButtonScheme()
            
            buttonScheme.cornerRadius = 8
            
            MDCContainedButtonThemer.applyScheme(buttonScheme, to: continueButton)
            
            continueButton.addTarget(
                self,
                action: #selector(onContinueButtonPressed(sender:)),
                for: .touchUpInside
            )
        }
    }
    
    var dataSource: WelcomeScreenDataSource? {
        didSet {
            guard let dataSource = dataSource else {
                return
            }
            
            welcomeLabel.text = dataSource.welcomeMessage
            usernameLabel.text = dataSource.username
        }
    }
    
    var presenter: WelcomeScreenPresenterProtocol?
}

// MARK: - Lifecycle
extension WelcomeScreenViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
    }
}

// MARK: - Button target
extension WelcomeScreenViewController {
    @objc func onContinueButtonPressed(sender: UIButton) {
        presenter?.onContinueButtonPressed()
    }
}

// MARK: - WelcomeScreenViewProtocol
extension WelcomeScreenViewController: WelcomeScreenViewProtocol {
    func set(dataSource: WelcomeScreenDataSource) {
        self.dataSource = dataSource
    }
}
