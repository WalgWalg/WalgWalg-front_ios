//
//  HealthService.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/07/04.
//

import UIKit

class HealthService{
    static var shared = HealthService()
    var StepCount:Int = 0
    var Distance:Double = 0.0
    var Kcal:Double = 0.0
    var Time:String = "00:00"
}
