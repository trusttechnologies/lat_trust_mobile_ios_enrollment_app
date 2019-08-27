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
        view?.startActivityIndicator()
//        interactor?.getAudits()
    }
    
    func onRefreshControlPulled() {
//        interactor?.getAudits()
    }
    
    func onLogoutButtonPressed() {
        view?.startActivityIndicator()
        interactor?.performLogout()
    }
    
    func onNotificationReceived(with auditID: String) {
//        receivedAuditID = auditID
        
//        view?.startActivityIndicator()
//        interactor?.getAudits()
    }
}

// MARK: - InteractorOutput
extension MainScreenPresenter: MainScreenInteractorOutput {
    func onLogoutPerformed() {
        //NOTHING
    }
    
    func onGetProfileDataSourceOutput(datasource: ProfileDataSource?) {
        view?.set(profileDataSource: datasource)
    }
    
    func onCleanedData() {
        view?.stopActivityIndicator()
        router?.goToMainScreen()
    }
}
