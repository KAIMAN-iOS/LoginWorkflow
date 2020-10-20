//
//  ViewController.swift
//  iosExample
//
//  Created by GG on 19/10/2020.
//

import UIKit
import LoginWorkflow
import KCoordinatorKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    lazy var coor = LoginWorkflowCoordinator<Int>(router: Router(navigationController: navigationController!), delegate: self)
    @IBAction func showLogin(_ sender: Any) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        let ctrl = coor.toPresentable()
        navigationController?.pushViewController(ctrl, animated: true)
    }
}

extension ViewController: LoginWorkflowCoordinatorDelegate {
    func forgotPassword() {
        
    }
    
    func showTerms() {
        
    }
    
    func showPrivacy() {
            
    }
    
    func login(_ user: LoginUser, completion: @escaping (() -> Void)) {
            
    }
    
    func signup(_ user: SignupUser, completion: @escaping (() -> Void)) {
            
    }
}

