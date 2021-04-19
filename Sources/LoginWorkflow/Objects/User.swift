//
//  File.swift
//  
//
//  Created by GG on 19/10/2020.
//

import Foundation
import PhoneNumberKit
import ATACommonObjects

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
    public let phone: String
    public let countryCode: String // "fr"
    public let internationalCode: String // "+33"
    public let firstname: String
    public let lastname: String
    public var internationalPhone: String {
        guard let internationalCode = BaseUser.numberKit.countryCode(for: countryCode),
            let nummber = try? BaseUser.numberKit.parse("\(internationalCode)\(phone)") else { return phone }
        return BaseUser.numberKit.format(nummber, toType: .e164)
    }
    
    public init(email: String,
                password: String,
                phone: String,
                countryCode: String,
                internationalCode: String,
                firstname: String,
                lastname: String) {
        self.phone = phone
        self.countryCode = countryCode
        self.firstname = firstname
        self.lastname = lastname
        self.internationalCode = internationalCode
        super.init(email: email, password: password)
    }
}
