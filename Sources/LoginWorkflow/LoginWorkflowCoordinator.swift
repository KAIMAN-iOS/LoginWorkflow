//
//  File.swift
//  
//
//  Created by GG on 16/10/2020.
//

import UIKit
import KCoordinatorKit
import ATAConfiguration
import Lottie
import ATAViews

protocol LoginLogicCoordinatorDelegate: NSObjectProtocol {
    func showLogin()
    func showSignUp()
}

public protocol LoginWorkflowCoordinatorDelegate: NSObjectProtocol {
    func forgotPassword()
    func showTerms()
    func showPrivacy()
    func login(_ user: LoginUser, completion: @escaping (() -> Void))
    func signup(_ user: SignupUser, completion: @escaping (() -> Void))
}

public struct LoginWorkflow {
    public enum Mode {
        case driver, passenger, business
    }
}

public class LoginWorkflowCoordinator<DeepLinkType>: Coordinator<DeepLinkType> {
    private var chooseController: LoginWorkflowController!
    private var loginBackgroundImage: UIImage? = nil
    weak var flowDelegate: LoginWorkflowCoordinatorDelegate!
    var mode: LoginWorkflow.Mode = .driver
    
    public init(router: RouterType,
                mode: LoginWorkflow.Mode = .driver,
                delegate: LoginWorkflowCoordinatorDelegate,
                animation: LottieAnimation? = nil,
                conf: ATAConfiguration) {
        super.init(router: router)
        BorderedErrorView.configuration = conf
//        LoginWorkflowCoordinator.configuration = conf
        chooseController = LoginWorkflowController.create(coordinatorDelegate: self, conf: conf, mode: mode)
        chooseController.animation = animation
        self.mode = mode
        flowDelegate = delegate
    }
    
    deinit {
        print("💀 DEINIT \(URL(fileURLWithPath: #file).lastPathComponent)")
    }
    
    public override func toPresentable() -> UIViewController {
        chooseController
    }
    
    private func showForm(_ signUpType: SignUpType) {
        let form: FormController = FormController.create(coordinatorDelegate: flowDelegate, signUpType: signUpType, mode: mode)
        form.animation = chooseController.animation
//        router.navigationController.setNavigationBarHidden(false, animated: true)
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


