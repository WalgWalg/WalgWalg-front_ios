//
//  LoginService.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/07/06.
//

import Foundation

class LoginService{
    static var shared = LoginService()
    var userID: String?
    var accessToken: String?
}
