//
//  PermissionsManager.swift
//  enrollment
//
//  Created by Kevin Torres on 14-10-19.
//  Copyright © 2019 Kevin Torres. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

// MARK: - PermissionsManagerProtocol
protocol PermissionsManagerProtocol: AnyObject {
    func checkBothPermissions()
}

// MARK: - PermissionsManagerOutputProtocol
protocol PermissionsManagerOutputProtocol: AnyObject {
    func permissionsSuccess()
    func permissionsFail()
}

class PermissionsManager: PermissionsManagerProtocol {
    
    weak var managerOutput: PermissionsManagerOutputProtocol?

    func checkBothPermissions() {
        let status = CLLocationManager.authorizationStatus()
    
            if status == .authorizedAlways || status == .authorizedWhenInUse { //Si fue autorizado pregunto por notification
                
                if !UIApplication.shared.isRegisteredForRemoteNotifications { //Permiso notificacion aceptado?, no aceptado ->
                    DispatchQueue.main.async {
                        self.managerOutput?.permissionsFail()
                    }
                } else {  //Si fue autorizado muestra main
                    //mostrar perfil usuario normalmente...
                    managerOutput?.permissionsSuccess()
                }
            }
            else { //Si no fue autorizado muestro alerta con la opcion de "aceptar y se cierra"
                self.managerOutput?.permissionsFail()

//                managerOutput?.callAlert(alertController: alertController)
            }
        
    }
    
}
