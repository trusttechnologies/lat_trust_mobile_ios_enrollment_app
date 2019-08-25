//
//  MainScreenPresenter.swift
//  enrollment
//
//  Created by Kevin Torres on 8/21/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

// MARK: - Presenter
class MainScreenPresenter: MainScreenPresenterProtocol {
    weak var view: MainScreenViewProtocol?
    var interactor: MainScreenInteractorProtocol?
    var router: MainScreenRouterProtocol?
    
//    var receivedAuditID: String?
    
    func onViewDidLoad() {
        interactor?.getProfileDataSource()
//        interactor?.getAuditsDataSource()
    }
    
    func onViewWillAppear() {
//        view?.startActivityIndicator()
//        interactor?.getAudits()
    }
    
    func onRefreshControlPulled() {
//        interactor?.getAudits()
    }
    
    func onLogoutButtonPressed() {
//        view?.startActivityIndicator()
        interactor?.performLogout()
    }
    
   /* func onReportActivityButtonPressed(with auditID: String) {
        router?.presentAlertView(
            with: .reportActivityQuestion,
            acceptAction: {
                [weak self] _ in
                
                guard let self = self else {
                    return
                }
                
                self.view?.startActivityIndicator()
                self.interactor?.reportAuditUsing(auditID: auditID)
            }, cancelAction: {
                [weak self] _ in
                
                guard let self = self else {
                    return
                }
                
                self.view?.closeTransactionDetailBottomSheet(completion: nil)
            }
        )
    }*/
    
    func onNotificationReceived(with auditID: String) {
//        receivedAuditID = auditID
        
//        view?.startActivityIndicator()
//        interactor?.getAudits()
    }
}

// MARK: - InteractorOutput
extension MainScreenPresenter: MainScreenInteractorOutput {
    func onLogoutPerformed() {
        //TODO
    }
    
    func onGetProfileDataSourceOutput(datasource: ProfileDataSource?) {
        view?.set(profileDataSource: datasource)
    }
    
    /*func onGetAuditsDataSourceOutput(dataSource: [AuditCellDataSource & AuditDetailDataSource]?) {
        view?.set(auditsDataSource: dataSource)
        
        guard let receivedAuditID = receivedAuditID else {
            return
        }
        
        view?.openTransactionDetailBottomSheet(with: receivedAuditID)
        
        self.receivedAuditID = nil
    }
    
    func onReportAuditResponse() {
        view?.stopActivityIndicator()
    }
    
    func onReportAuditSuccess() {
        interactor?.getAudits()
        
        router?.presentAlertView(
            with: .successfulReport,
            acceptAction: {
                [weak self] _ in
                
                guard let self = self else {
                    return
                }
                
                self.view?.closeTransactionDetailBottomSheet(completion: nil)
            }, cancelAction: nil
        )
    }
    
    func onReportAuditFailure(with errorMessage: String) {
        router?.presentAlertView(
            with: errorMessage,
            acceptAction: {
                [weak self] _ in
                
                guard let self = self else {
                    return
                }
                
                self.view?.closeTransactionDetailBottomSheet(completion: nil)
                
            }, cancelAction: nil
        )
    }
    
    func onGetAuditsResponse() {
        view?.stopRefresher()
        view?.stopActivityIndicator()
    }
    
    func onGetAuditsSuccess() {
        interactor?.getAuditsDataSource()
    }
    
    func onGetAuditsFailure() {
        router?.presentAlertView(
            with: .defaultAlertMessage,
            acceptAction: nil,
            cancelAction: nil
        )
    }
    
    func onLogoutPerformed() {
        interactor?.clearFirebaseToken()
    }
    
    func onClearedFirebaseToken() {
        interactor?.cleanData()
    }*/
    
    func onCleanedData() {
//        view?.stopActivityIndicator()
        router?.goToMainScreen()
    }
}
