//
//  MainScreenViewController.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit
import MaterialComponents

// MARK: ProfileDataSource
protocol ProfileDataSource {
    var name: String? {get}
    var rut: String? {get}
}

class MainScreenViewController: UIViewController {
    
    var presenter: MainScreenPresenterProtocol?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rutLabel: UILabel!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var profileDataSource: ProfileDataSource? {
        didSet {
            guard let dataSource = profileDataSource else { return }
            nameLabel.text = dataSource.name?.capitalized
            rutLabel.text = dataSource.rut
        }
    }
    
    @IBOutlet weak var logoutButton: MDCButton! {
        didSet {
            logoutButton.setupButtonWithType(type: .btnSecondary, mdcType: .contained)
            
            logoutButton.addTarget(
                self,
                action: #selector(onLogoutButtonPressed(sender:)),
                for: .touchUpInside
            )
        }
    }
}

// MARK: - View
extension MainScreenViewController: MainScreenViewProtocol {
    func set(profileDataSource: ProfileDataSource?) {
        self.profileDataSource = profileDataSource
    }
}

// MARK: - Buttons targets
extension MainScreenViewController {
    @objc func onLogoutButtonPressed(sender: UIButton) {
        self.presenter?.onLogoutButtonPressed()
    }
}


// MARK: - Lifecycle
extension MainScreenViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }
}
