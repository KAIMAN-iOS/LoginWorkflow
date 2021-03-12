//
//  File.swift
//  
//
//  Created by GG on 16/10/2020.
//

import UIKit
import Ampersand

public enum SignUpType: Int {
    case login, sigup
    
    var title: String {
        switch self {
        case .login: return NSLocalizedString("Log in", bundle: Bundle.module, comment: "Log in").uppercased()
        case .sigup: return NSLocalizedString("Sign up", bundle: Bundle.module, comment: "Sign up").uppercased()
        }
    }
}

public class SignUpButton: UIButton {
    
    public var selectedBackgroundColor: UIColor = LoginWorkflowController.configuration.palette.textOnPrimary
    public var selectedTitleColor: UIColor = LoginWorkflowController.configuration.palette.mainTexts
    public var hasFocus: Bool = false {
        didSet {
            layoutIfNeeded()
        }
    }
    
    public var signUpType: SignUpType = .login  {
        didSet {
            titleLabel?.font = .applicationFont(forTextStyle: .body)
            setTitle(signUpType.title, for: .normal)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = hasFocus ? selectedBackgroundColor : .clear
        layer.borderWidth = 0.5
        layer.borderColor = selectedBackgroundColor.cgColor
        setTitleColor(hasFocus ? selectedTitleColor : selectedBackgroundColor, for: .normal)
        layer.cornerRadius = 5.0
    }
}
