//
//  File.swift
//  
//
//  Created by GG on 16/10/2020.
//

import UIKit

class LoginWorflowController: UIViewController {
 
    static func create(coordinatorDelegate: LoginWorflowCoordinatorDelegate) -> LoginWorflowController {
        let ctrl:LoginWorflowController = UIStoryboard(name: "LoginWorflow", bundle: Bundle.module).instantiateViewController(identifier: "LoginWorflowController") as! LoginWorflowController
        ctrl.coordinatorDelegate = coordinatorDelegate
        return ctrl
    }
    weak var coordinatorDelegate: LoginWorflowCoordinatorDelegate?
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var signUpButton: SignUpButton!  {
        didSet {
            signUpButton.signUpType = .sigup
            signUpButton.hasFocus = true
        }
    }

    @IBOutlet weak var loginButton: SignUpButton!  {
        didSet {
            loginButton.signUpType = .login
        }
    }
    
    @IBAction func login() {
        coordinatorDelegate?.showLogin()
    }
    @IBAction func signup() {
        coordinatorDelegate?.showSignUp()
    }
}
