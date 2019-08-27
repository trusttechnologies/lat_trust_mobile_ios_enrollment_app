//
//  MainScreenProtocols.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - View
protocol MainScreenViewProtocol: AnyObject {
    func startActivityIndicator()
    func stopActivityIndicator()
    
    func set(profileDataSource: ProfileDataSource?)
}

// MARK: - Interactor
protocol MainScreenInteractorProtocol: AnyObject {
    var interactorOutput: MainScreenInteractorOutput? {get set}
    
    var userDataManager: UserDataManagerProtocol? {get set}
    
    func getProfileDataSource()
    
    func performLogout()
    func cleanData()
}

// MARK: - InteractorOutput
protocol MainScreenInteractorOutput: AnyObject {
    func onGetProfileDataSourceOutput(datasource: ProfileDataSource?)
    
    func onLogoutPerformed()
    
    func onCleanedData()
}

// MARK: - Presenter
protocol MainScreenPresenterProtocol: AnyObject {
    var view: MainScreenViewProtocol? {get set}
    var interactor: MainScreenInteractorProtocol? {get set}
    var router: MainScreenRouterProtocol? {get set}
    
    func onViewDidLoad()
    func onViewWillAppear()
    
    func onRefreshControlPulled()
    
    func onLogoutButtonPressed()
    
    func onNotificationReceived(with auditID: String)
}

// MARK: - Router
protocol MainScreenRouterProtocol: AnyObject {
    var viewController: UIViewController? {get set}
    
    static func createModule() -> MainScreenViewController
    func goToMainScreen()
    func presentAlertView(with message: String, acceptAction: ((UIAlertAction) -> Void)?, cancelAction: ((UIAlertAction) -> Void)?)
}
