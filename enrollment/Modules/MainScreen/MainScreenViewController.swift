//
//  MainScreenViewController.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit
import MaterialComponents
import TrustDeviceInfo

// MARK: ProfileDataSource
protocol ProfileDataSource {
    var name: String? {get}
    var rut: String? {get}
}

class MainScreenViewController: UIViewController {
    

    @IBAction func testError(_ sender: Any) {
        Identify.shared.setAppState(dni: "", bundleID: "com.trust.enrollment.ios")

    }
    var presenter: MainScreenPresenterProtocol?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rutLabel: UILabel!
    @IBOutlet weak var trustIdLabel: UILabel!
    
    // MARK: - Permission message
    @IBOutlet weak var permissionsMessage: UIView!
    @IBOutlet weak var permissionsBackground: UIView! {
        didSet {
            permissionsBackground?.backgroundColor = .blackBackground
        }
    }
    
    @IBOutlet weak var acceptMessageButton: MDCButton!{
        didSet {
//            acceptMessageButton.setupButtonWithType(type: .btnSecondary, mdcType: .contained)
            
            acceptMessageButton.addTarget(
                self,
                action: #selector(onAcceptMessageButtonPressed(sender:)),
                for: .touchUpInside
            )
        }
    }
    
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
    
    func setTrustId(trustIdDataSource: String?) {
        trustIdLabel.text = trustIdDataSource
    }
    
    func showPermissionModal() {
        permissionsMessage.show()
        permissionsBackground.show()
    }
    
    func hidePermissionModal() {
        permissionsMessage.hide()
        permissionsBackground.hide()
    }
}

extension MainScreenViewController: TrustDeviceInfoDelegate {
    func onClientCredentialsSaved(savedClientCredentials: ClientCredentials) {
//        Identify.shared.setAppState(dni: "", bundleID: "com.trust.enrollment.ios")
    }
    
    func onTrustIDSaved(savedTrustID: String) {
        //
    }
    
    func onRegisterFirebaseTokenSuccess(responseData: RegisterFirebaseTokenResponse) {
        //
    }
    
    func onSendDeviceInfoResponse(status: ResponseStatus) {
        //
    }
    
    
}

// MARK: - Buttons targets
extension MainScreenViewController {
    @objc func onLogoutButtonPressed(sender: UIButton) {
        self.presenter?.onLogoutButtonPressed()
    }
    @objc func onAcceptMessageButtonPressed(sender: UIButton) {
        self.presenter?.openEnrollmentSettings()
        self.hidePermissionModal()
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
