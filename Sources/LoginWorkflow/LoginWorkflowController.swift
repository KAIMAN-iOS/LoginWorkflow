//
//  File.swift
//  
//
//  Created by GG on 16/10/2020.
//

import UIKit
import ATAConfiguration

public class LoginWorkflowController: UIViewController {
 
    static var configuration: ATAConfiguration!
    static func create(coordinatorDelegate: LoginLogicCoordinatorDelegate, conf: ATAConfiguration) -> LoginWorkflowController {
        let ctrl:LoginWorkflowController = UIStoryboard(name: "LoginWorkflow", bundle: Bundle.module).instantiateViewController(identifier: "LoginWorkflowController") as! LoginWorkflowController
        ctrl.logicDelegate = coordinatorDelegate
        LoginWorkflowController.configuration = conf
        return ctrl
    }
    weak var logicDelegate: LoginLogicCoordinatorDelegate!
    @IBOutlet weak var icon: UIImageView! 
    @IBOutlet weak var appNameLabel: UILabel!
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
    
    public var appName: String?
    public var imageName: String?
    public var backgroundColor: UIColor?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let name = appName {
            appNameLabel.text = name
        }
        if let name = imageName,
           let image = UIImage(named: name) {
            icon.image = image
        }
        if let color = backgroundColor {
            view.backgroundColor = color
        }
    }
    
    @IBAction func login(_ sender: Any) {
        logicDelegate?.showLogin()
    }
    @IBAction func signup(_ sender: Any) {
        logicDelegate?.showSignUp()
    }
}
