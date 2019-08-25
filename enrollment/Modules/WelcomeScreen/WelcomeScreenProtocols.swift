//
//  WelcomeScreenProtocols.swift
//  enrollment
//
//  Created by Kevin Torres on 8/24/19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit

// MARK: - View
protocol WelcomeScreenViewProtocol: AnyObject {
    func set(dataSource: WelcomeScreenDataSource)
}

// MARK: - Interactor
protocol WelcomeScreenInteractorProtocol: AnyObject {
    var interactorOutput: WelcomeScreenInteractorOutput? {get set}
    
    var userDataManager: UserDataManagerProtocol? {get set}
    
    func getWelcomeScreenDataSource()
}

// MARK: - InteractorOutput
protocol WelcomeScreenInteractorOutput: AnyObject {
    func onGetWelcomeScreenDataSourceOutput(dataSource: WelcomeScreenDataSource)
}

// MARK: - Presenter
protocol WelcomeScreenPresenterProtocol: AnyObject {
    var view: WelcomeScreenViewProtocol? {get set}
    var interactor: WelcomeScreenInteractorProtocol? {get set}
    var router: WelcomeScreenRouterProtocol? {get set}
    
    func onViewDidLoad()
    func onContinueButtonPressed()
}

// MARK: - Router
protocol WelcomeScreenRouterProtocol: AnyObject {
    var viewController: UIViewController? {get set}
    var delegate: WelcomeScreenRouterDelegate? {get set}
    
    static func createModule(delegate: WelcomeScreenRouterDelegate?) -> WelcomeScreenViewController
    func dismiss()
}
