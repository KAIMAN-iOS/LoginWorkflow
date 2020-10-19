//
//  File.swift
//  
//
//  Created by GG on 16/10/2020.
//

import UIKit
import KCoordinatorKit

protocol LoginWorflowCoordinatorDelegate: class {
    func showLogin()
    func showSignUp()
}

class LoginWorflowCoordinator<DeepLinkType>: Coordinator<DeepLinkType> {
    
    override init(router: RouterType) {
        super.init(router: router)
    }
}

extension LoginWorflowCoordinator: LoginWorflowCoordinatorDelegate {
    func showLogin() {
        
    }
    
    func showSignUp() {
        
    }
}
