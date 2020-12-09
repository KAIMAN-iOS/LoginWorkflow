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
    @IBOutlet weak var welcomeTitle: UILabel!  {
        didSet {
            welcomeTitle.text = "welcome title".bundleLocale().uppercased()
            welcomeTitle.textColor = UIColor.white.withAlphaComponent(0.8)
            welcomeTitle.font = UIFont.applicationFont(ofSize: 13, weight: .thin)
        }
    }

    @IBOutlet weak var welcomeMessage: UILabel!  {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = .right
            welcomeMessage.attributedText = NSAttributedString(string: "welcome message".bundleLocale().uppercased(),
                                                               attributes: [.paragraphStyle : paragraphStyle,
                                                                            .font : UIFont.applicationFont(ofSize: 9, weight: .thin),
                                                                            .foregroundColor : UIColor.white.withAlphaComponent(0.8)])
            welcomeMessage.superview?.layoutIfNeeded()
            
        }
    }

    @IBOutlet weak var welcomeView: UIView!  {
        didSet {
            welcomeView.setRoundedCorners(corners: [.topLeft, .bottomLeft], radius: 20.0)
            welcomeView.backgroundColor = LoginWorkflowController.configuration.palette.mainTexts.darker(by: 2)
        }
    }
   
    public override var prefersStatusBarHidden: Bool { true }
    public var backgroundColor: UIColor?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let image = LoginWorkflowController.configuration.logo {
            icon.image = image
        }
        if let color = backgroundColor {
            view.backgroundColor = color
        } else {
            view.backgroundColor = LoginWorkflowController.configuration.palette.mainTexts
        }
    }
    
    @IBAction func login(_ sender: Any) {
        logicDelegate?.showLogin()
    }
    @IBAction func signup(_ sender: Any) {
        logicDelegate?.showSignUp()
    }
}
