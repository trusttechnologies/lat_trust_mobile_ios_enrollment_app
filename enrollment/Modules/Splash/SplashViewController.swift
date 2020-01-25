//
//  SplashViewController.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit
import TrustNotification

class SplashViewController: UIViewController {
    var presenter: SplashPresenterProtocol?
}

// MARK: - Lifecycle
extension SplashViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.onViewDidAppear()
    }
}

// MARK: - View
extension SplashViewController: SplashViewProtocol {}

