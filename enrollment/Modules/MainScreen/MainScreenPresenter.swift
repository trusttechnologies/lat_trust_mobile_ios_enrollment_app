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
    
    func onViewDidLoad() {
        interactor?.getProfileDataSource()
        interactor?.getTrustIdDataSource()
    }
    
    func onViewWillAppear() {
        interactor?.loginAudit()
    }
    
    func onRefreshControlPulled() {
        //TODO
    }
    
    func onLogoutButtonPressed() { //Start Logout
        interactor?.performLogout() //Use performLogout in MainScreenInteractor
    }
    
    func onNotificationReceived(with auditID: String) {
        //TODO
    }
}

// MARK: - InteractorOutput
extension MainScreenPresenter: MainScreenInteractorOutput {
    func onGetTrustIdDataSourceOutPut(trustId: String?) {
        view?.setTrustId(trustIdDataSource: trustId)
    }
    
    func onClearedData() {
        interactor?.cleanData()
    }
    
    func onLogoutPerformed() {
        interactor?.callCleanData() //use "Clean" data in MainScreenInteractor
    }
    
    func onGetProfileDataSourceOutput(datasource: ProfileDataSource?) {
        view?.set(profileDataSource: datasource)
    }
    
    func onCleanedData() {
        router?.goToMainScreen()
    }
}
