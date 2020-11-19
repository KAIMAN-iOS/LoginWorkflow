//
//  File.swift
//  
//
//  Created by GG on 16/10/2020.
//

import UIKit
import KCoordinatorKit
import IQKeyboardManagerSwift
import ATAConfiguration

protocol LoginLogicCoordinatorDelegate: class {
    func showLogin()
    func showSignUp()
}

public protocol LoginWorkflowCoordinatorDelegate: class {
    func forgotPassword()
    func showTerms()
    func showPrivacy()
    func login(_ user: LoginUser, completion: @escaping (() -> Void))
    func signup(_ user: SignupUser, completion: @escaping (() -> Void))
}

public class LoginWorkflowCoordinator<DeepLinkType>: Coordinator<DeepLinkType> {
    private var chooseController: LoginWorkflowController!
    weak var flowDelegate: LoginWorkflowCoordinatorDelegate!
    
    public init(router: RouterType, delegate: LoginWorkflowCoordinatorDelegate, conf: ATAConfiguration) {
        super.init(router: router)
//        LoginWorkflowCoordinator.configuration = conf
        chooseController = LoginWorkflowController.create(coordinatorDelegate: self, conf: conf)
        IQKeyboardManager.shared.enable = true
        flowDelegate = delegate
    }
    
    deinit {
        print("💀 DEINIT \(URL(fileURLWithPath: #file).lastPathComponent)")
    }
    
    public override func toPresentable() -> UIViewController {
        chooseController
    }
    
    private func showForm(_ signUpType: SignUpType) {
        let form: FormController = FormController.create(coordinatorDelegate: flowDelegate, signUpType: signUpType)
        router.navigationController.setNavigationBarHidden(true, animated: false)
        router.push(form, animated: true, completion: nil)
    }
}

extension LoginWorkflowCoordinator: LoginLogicCoordinatorDelegate {
    func showLogin() {
        showForm(.login)
    }
    
    func showSignUp() {
        showForm(.sigup)
    }
}

extension String {
    func bundleLocale() -> String {
        NSLocalizedString(self, bundle: .module, comment: self)
    }
}


