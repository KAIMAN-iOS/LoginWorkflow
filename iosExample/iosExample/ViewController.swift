//
//  ViewController.swift
//  iosExample
//
//  Created by GG on 19/10/2020.
//

import UIKit
import LoginWorkflow
import KCoordinatorKit
import ATAConfiguration

class Configuration: ATAConfiguration {
    var logo: UIImage? { nil }
    var palette: Palettable { Palette() }
}

class Palette: Palettable {
    var primary: UIColor { #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) }
    var secondary: UIColor { #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) }
    
    var mainTexts: UIColor { #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) }
    
    var secondaryTexts: UIColor { #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) }
    
    var textOnPrimary: UIColor { #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) }
    
    var inactive: UIColor { #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
    
    var placeholder: UIColor { #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
    var lightGray: UIColor { #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
    
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    lazy var coor = LoginWorkflowCoordinator<Int>(router: Router(navigationController: navigationController!), delegate: self, conf: Configuration())
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

