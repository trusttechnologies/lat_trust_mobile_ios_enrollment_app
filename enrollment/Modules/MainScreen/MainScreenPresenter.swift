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
        interactor?.checkBothPermissions()
        interactor?.getProfileDataSource()
        interactor?.getTrustIdDataSource()
    }
    
    func onViewWillAppear() {
        interactor?.loginAudit()
    }
    
    func onLogoutButtonPressed() { //Start Logout
        interactor?.performLogout() //Use performLogout in MainScreenInteractor
    }
    
    func openEnrollmentSettings() {
        interactor?.openSettings()
    }
}

// MARK: - InteractorOutput
extension MainScreenPresenter: MainScreenInteractorOutput {
    func showMessage() {
        view?.showPermissionModal()
    }
    
    func onGetTrustIdDataSourceOutPut(trustId: String?) {
        view?.setTrustId(trustIdDataSource: trustId)
    }
    
    func onClearedData() {
        interactor?.cleanData()
    }
    
    func onLogoutPerformed() {
        interactor?.cleanData()
    }
    
    func onGetProfileDataSourceOutput(datasource: ProfileDataSource?) {
        view?.set(profileDataSource: datasource)
    }
    
    func onCleanedData() {
        router?.goToMainScreen()
    }
}
