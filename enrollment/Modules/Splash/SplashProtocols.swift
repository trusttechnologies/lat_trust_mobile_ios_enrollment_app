//
//  SplashProtocols.swift
//  enrollment
//
//  Created by Kevin Torres on 8/20/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - View
protocol SplashViewProtocol: AnyObject {}

// MARK: - Presenter
protocol SplashPresenterProtocol: AnyObject {
    var view: SplashViewProtocol? {get set}
    var router: SplashRouterProtocol? {get set}
    
    func onViewDidAppear()
}

// MARK: - Router
protocol SplashRouterProtocol: AnyObject {
    var viewController: UIViewController? {get set}
    
    static func createModule() -> SplashViewController
    func goToLogin()
}
