//
//  HealthService.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/07/04.
//

import UIKit
import HealthKit

class HealthService: UIView {
    static var shared = HealthService()
    
    
    var StepCount:Double = 0.0
    var Distance:Double = 0.0
    var Kcal:Double = 0.0
    
    let healthStore = HKHealthStore()
    
    let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!, HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!])
    
    let share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!, HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!])
    
    func requestAuthorization(){
        self.healthStore.requestAuthorization(toShare: share, read: read) { (success, error) in
            if error != nil {
                print(error.debugDescription)
            }
            else {
                if success {
                    print("권한이 허락되었습니다.")
                }
                else{
                    print("권한이 없습니다.")
                }
            }
        }
    }
    
    func getStepCount(completion: @escaping (Double) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("fail")
                return
            }
            print("stepCount : \(result)")
            let step = sum.doubleValue(for: HKUnit.count())

            DispatchQueue.main.async {
                completion(step)
                self.StepCount = step
            }
        }
        healthStore.execute(query)
    }
    
    func getDistanceWalkingRunning(completion: @escaping (Double) -> Void) {
        guard let distanceWalkingRunningType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return
        }
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceWalkingRunningType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var distance: Double = 0
            guard let result = result, let sum = result.sumQuantity() else {
                print("fail")
                return
            }
            
            
            distance = (sum.doubleValue(for: HKUnit.meter()))/1000
            print("distance : \(distance)")
            DispatchQueue.main.async {
                completion(distance)
                // 결과 미터 단위
                // 1km = 1000m
                // 1m = 0.001Km
                self.Distance = distance
            }
        }
        healthStore.execute(query)
    }
    
    func getActivityEnergyBurned(completion: @escaping (Double) -> Void) {
        guard let activeEnergyBurnedType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: activeEnergyBurnedType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var cal: Double = 0
            guard let result = result, let sum = result.sumQuantity() else {
                print("fail")
                return
            }
            cal = sum.doubleValue(for: HKUnit.kilocalorie())
            print("Kcal : \(cal)")
            
            
            DispatchQueue.main.async {
                completion(cal)
                self.Kcal = cal
            }
        }
        healthStore.execute(query)
    }
    
    
}
