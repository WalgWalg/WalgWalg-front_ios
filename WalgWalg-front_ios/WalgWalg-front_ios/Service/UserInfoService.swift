//
//  GetUserInfoService.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/07/06.
//

import Foundation

class UserInfoService{
    static var shared = UserInfoService()
    var userID: String?
    var userNick: String?
    var userAddress: String?
    var accessToken: String?
}
