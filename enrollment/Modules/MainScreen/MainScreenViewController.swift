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

class MainScreenViewController: UIViewController {

    // MARK: - ProfileBottomSheetView
    var isProfileBottomSheetOpened = false
    
    var presenter: MainScreenPresenterProtocol?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rutLabel: UILabel!
    
    var profileDataSource: ProfileDataSource? {
        didSet {
            guard let dataSource = profileDataSource else { return }
            nameLabel.text = dataSource.name
            rutLabel.text = dataSource.rut
        }
    }
    
    @IBOutlet weak var logoutButton: MDCButton! {
        didSet {
            logoutButton.setupButtonWithType(type: .btnSecondary, mdcType: .contained)
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
        closeProfileBottomSheet() {
            [weak self] in
            
            guard let self = self else {
                return
            }
            
            self.presenter?.onLogoutButtonPressed()
        }
    }
}

// MARK: - Profile Bottom Sheet Methods
extension MainScreenViewController {
    func closeProfileBottomSheet(completion: CompletionHandler = nil) {
        guard isProfileBottomSheetOpened else {
            return
        }
    }
}
