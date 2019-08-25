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
//    func openTransactionDetailBottomSheet(with receivedAuditID: String)
//    func closeTransactionDetailBottomSheet(completion: CompletionHandler)
//    func startActivityIndicator()
//    func stopActivityIndicator()
//    func stopRefresher()
    
    func set(profileDataSource: ProfileDataSource?)
//    func set(auditsDataSource: [AuditCellDataSource & AuditDetailDataSource]?)
}

// MARK: - Interactor
protocol MainScreenInteractorProtocol: AnyObject {
    var interactorOutput: MainScreenInteractorOutput? {get set}
    
//    var firebaseTokenManager: FirebaseTokenManagerProtocol? {get set}
    var userDataManager: UserDataManagerProtocol? {get set}
    
    func getProfileDataSource()
//    func getAuditsDataSource()
    
//    func getAudits()
//    func reportAuditUsing(auditID: String)
    func performLogout()
    func cleanData()
//    func clearFirebaseToken()
}

// MARK: - InteractorOutput
protocol MainScreenInteractorOutput: AnyObject {
    func onGetProfileDataSourceOutput(datasource: ProfileDataSource?)
//    func onGetAuditsDataSourceOutput(dataSource: [AuditCellDataSource & AuditDetailDataSource]?)
    
//    func onGetAuditsResponse()
//    func onGetAuditsSuccess()
//    func onGetAuditsFailure()
    
//    func onReportAuditResponse()
//    func onReportAuditSuccess()
//    func onReportAuditFailure(with errorMessage: String)
    
    func onLogoutPerformed()
    
    func onCleanedData()
    
//    func onClearedFirebaseToken()
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
//    func onReportActivityButtonPressed(with auditID: String)
    
    func onNotificationReceived(with auditID: String)
}

// MARK: - Router
protocol MainScreenRouterProtocol: AnyObject {
    var viewController: UIViewController? {get set}
    
    static func createModule() -> MainScreenViewController
    func goToMainScreen()
    func presentAlertView(with message: String, acceptAction: ((UIAlertAction) -> Void)?, cancelAction: ((UIAlertAction) -> Void)?)
}
