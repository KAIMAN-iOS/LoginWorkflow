//
//  File.swift
//  
//
//  Created by GG on 19/10/2020.
//

import UIKit
import LabelExtension
import FontExtension

protocol CloseDelegate: class {
    func close(_ view: UIView)
}

class LoginErrorView: UIView {
    static func load() -> LoginErrorView {
        Bundle.module.loadNibNamed("LoginErrorView", owner: nil, options: nil)!.first! as! LoginErrorView
    }
    @IBOutlet weak var closeButton: UIButton!  {
        didSet {
            closeButton.tintColor = LoginWorkflowController.configuration.palette.primary
        }
    }

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var coloredBackgroundView: UIView!  {
        didSet {
            coloredBackgroundView.backgroundColor = LoginWorkflowController.configuration.palette.primary
        }
    }

    @IBOutlet weak var strokedBackgroundView: UIView!  {
        didSet {
            strokedBackgroundView.cornerRadius = 5.0
            strokedBackgroundView.layer.borderWidth = 1.0
            strokedBackgroundView.layer.borderColor = LoginWorkflowController.configuration.palette.primary.cgColor
            strokedBackgroundView.backgroundColor = .white
        }
    }
    weak var closeDelegate: CloseDelegate?
    
    @IBAction func close() {
        closeDelegate?.close(self)
    }
    
    
    func configure(_ text: String, delegate: CloseDelegate) {
        closeDelegate = delegate
        errorLabel.set(text: text, for: .footnote, textColor: LoginWorkflowController.configuration.palette.primary)
    }
}
