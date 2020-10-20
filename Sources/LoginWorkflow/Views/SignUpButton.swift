//
//  File.swift
//  
//
//  Created by GG on 16/10/2020.
//

import UIKit

public enum SignUpType: Int {
    case login, sigup
    
    var title: String {
        switch self {
        case .login: return NSLocalizedString("Log in", bundle: Bundle.module, comment: "Log in")
        case .sigup: return NSLocalizedString("Sign up", bundle: Bundle.module, comment: "Sign up")
        }
    }
}

public class SignUpButton: UIButton {
    
    public var selectedBackgroundColor: UIColor = .white
    public var selectedTitleColor: UIColor = .red
    public var hasFocus: Bool = false {
        didSet {
            layoutIfNeeded()
        }
    }
    
    public var signUpType: SignUpType = .login  {
        didSet {
            setTitle(signUpType.title, for: .normal)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = hasFocus ? selectedBackgroundColor : .clear
        layer.borderWidth = 1.0
        layer.borderColor = selectedBackgroundColor.cgColor
        setTitleColor(hasFocus ? selectedTitleColor : selectedBackgroundColor, for: .normal)
        layer.cornerRadius = 5.0
    }
}
