//
//  File.swift
//  
//
//  Created by GG on 16/10/2020.
//

import UIKit
import ATAConfiguration
import UIViewExtension
import StringExtension
import Ampersand
import Lottie

public class LoginWorkflowController: UIViewController {
    var mode: LoginWorkflow.Mode!
    static var configuration: ATAConfiguration!
    static func create(coordinatorDelegate: LoginLogicCoordinatorDelegate, conf: ATAConfiguration, mode: LoginWorkflow.Mode) -> LoginWorkflowController {
        let ctrl:LoginWorkflowController = UIStoryboard(name: "LoginWorkflow", bundle: Bundle.module).instantiateViewController(identifier: "LoginWorkflowController") as! LoginWorkflowController
        ctrl.logicDelegate = coordinatorDelegate
        ctrl.mode = mode
        LoginWorkflowController.configuration = conf
        return ctrl
    }
    var animation: Animation?
    weak var logicDelegate: LoginLogicCoordinatorDelegate!
    @IBOutlet weak var icon: UIImageView! 
    @IBOutlet weak var signUpButton: SignUpButton!  {
        didSet {
            signUpButton.signUpType = .sigup
        }
    }
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var loginButton: SignUpButton!  {
        didSet {
            loginButton.signUpType = .login
            loginButton.hasFocus = true
        }
    }
    public override var prefersStatusBarHidden: Bool { true }
    public var backgroundColor: UIColor? = #colorLiteral(red: 0.09803921729, green: 0.09803921729, blue: 0.09803921729, alpha: 1)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        subtitle.set(text: (mode == .driver ? "welcome driver" : "welcome passenger").bundleLocale(), for: .footnote, textColor: LoginWorkflowController.configuration.palette.textOnDark)
        if let image = LoginWorkflowController.configuration.logo {
            icon.image = image
        }
        if let color = backgroundColor {
            view.backgroundColor = color
        } else {
            view.backgroundColor = LoginWorkflowController.configuration.palette.background
        }
        if mode == .passenger {
            signUpButton.isHidden = true
            loginButton.setTitle("start experience".bundleLocale().uppercased(), for: .normal)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        logicDelegate?.showLogin()
    }
    @IBAction func signup(_ sender: Any) {
        logicDelegate?.showSignUp()
    }
}
