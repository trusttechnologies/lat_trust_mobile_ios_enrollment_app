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
    var gender: Gender? {get}
}

/*
// MARK: AuditDetailDataSource
protocol AuditDetailDataSource {
    var id: String? {get}
    var reported: Bool {get}
    var title: String? {get}
    var strategyIcon: UIImage? {get}
    var strategyAsString: String? {get}
    var date: Date? {get}
    var personName: String? {get}
    var personDNI: String? {get}
    var operatorName: String? {get}
    var operatorDNI: String? {get}
}
*/

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
    /*func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }*/
    
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
