//
//  WelcomeScreenInteractor.swift
//  enrollment
//
//  Created by Kevin Torres on 8/24/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

// MARK: - Interactor
class WelcomeScreenInteractor: WelcomeScreenInteractorProtocol {
    weak var interactorOutput: WelcomeScreenInteractorOutput?
    
    var userDataManager: UserDataManagerProtocol?
    
    func getWelcomeScreenDataSource() {
        guard let user = userDataManager?.getUser() else {
            return
        }
        
        interactorOutput?.onGetWelcomeScreenDataSourceOutput(dataSource: user)
    }
}
