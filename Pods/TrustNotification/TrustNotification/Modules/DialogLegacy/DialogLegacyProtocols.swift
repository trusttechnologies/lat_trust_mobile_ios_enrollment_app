//
//  DialogLegacyProtocols.swift
//  TrustNotification
//
//  Created by Jesenia Salazar on 11-12-19.
//  Copyright © 2019 Trust. All rights reserved.
//

import Foundation

protocol DialogLegacyViewProtocol: UIViewController {
    var data: NotificationInfo? {get set}
}

protocol DialogLegacyInteractorProtocol: AnyObject {
    var interactorOutput: DialogLegacyInteractorOutputProtocol? {get set}
    var callbackDataManager: CallbackDataManagerProtocol? {get set}
    
    func onUserPerformAction(data: NotificationInfo, action: String)
    func onShowNotificationError()
}

protocol DialogLegacyInteractorOutputProtocol: AnyObject {
    func onCallbackSuccess()
    func onCallbackFailure()
}

protocol DialogLegacyPresenterProtocol: AnyObject {
    var view: DialogLegacyViewProtocol? {get set}
    var interactor: DialogLegacyInteractorProtocol? {get set}
    var router: DialogLegacyRouterProtocol? {get set}
    
    func onCloseButtonPressed()
    func onActionButtonPressed(action: String)
}

protocol DialogLegacyRouterProtocol: AnyObject {
    var viewController: UIViewController? {get set}
    
    static func createModule() -> DialogLegacyViewController
    
    func dismiss()
    func onActionButtonPressed()
}
