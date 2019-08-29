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
//        interactor?.getTrustIdDataSource()
//        interactor?.getAuditsDataSource()
    }
    
    func onViewWillAppear() {
//        view?.startActivityIndicator()
//        interactor?.getAudits()
    }
    
    func onRefreshControlPulled() {
//        interactor?.getAudits()
    }
    
    func onLogoutButtonPressed() { //Start Logout
//        view?.startActivityIndicator()
        interactor?.performLogout() //Use performLogout in MainScreenInteractor
    }
    
    func onNotificationReceived(with auditID: String) {
//        receivedAuditID = auditID
        
//        view?.startActivityIndicator()
//        interactor?.getAudits()
    }
}

// MARK: - InteractorOutput
extension MainScreenPresenter: MainScreenInteractorOutput {
    func onClearedData() {
        interactor?.cleanData()
    }
    
    func onLogoutPerformed() {
//        router?.dismiss()
        interactor?.cleanThings() //use "Clean" data in MainScreenInteractor
    }
    
    func onGetProfileDataSourceOutput(datasource: ProfileDataSource?) {
        view?.set(profileDataSource: datasource)
    }
    
    func onCleanedData() {
//        view?.stopActivityIndicator()
        router?.goToMainScreen()
    }
}
