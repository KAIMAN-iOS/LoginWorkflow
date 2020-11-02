//
//  File.swift
//  
//
//  Created by GG on 19/10/2020.
//

import Foundation
import PhoneNumberKit

public class LoginUser: NSObject {
    public let email: String
    public let password: String
    
    public init(email: String,
                password: String) {
        self.email = email
        self.password = password
    }
}

public class SignupUser: LoginUser {
    static let phoneNumberKit = PhoneNumberKit()
    public let phone: String
    public let countryCode: String
    public let firstname: String
    public let lastname: String
    public var internationalPhone: String {
        guard let nummber = try? SignupUser.phoneNumberKit.parse(phone) else { return phone }
        return SignupUser.phoneNumberKit.format(nummber, toType: .international)
    }
    
    public init(email: String,
                password: String,
                phone: String,
                countryCode: String,
                firstname: String,
                lastname: String) {
        self.phone = phone
        self.countryCode = countryCode
        self.firstname = firstname
        self.lastname = lastname
        super.init(email: email, password: password)
    }
}
