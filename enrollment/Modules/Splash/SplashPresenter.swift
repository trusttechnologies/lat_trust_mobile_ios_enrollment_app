//
//  SplashPresenter.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

// MARK: - Presenter
class SplashPresenter: SplashPresenterProtocol {
    weak var view: SplashViewProtocol?
    var router: SplashRouterProtocol?
    
    func onViewDidAppear() {
        router?.goToLogin()
    }
}
