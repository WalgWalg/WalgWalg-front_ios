
//  CurrentWeather.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/01/21.
//
import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    var city:String = ""
    var temp:Double = 0.0
    var weatherInfo:String = ""
    
    //completion으로 콜백함수 만들기
    func getCurrentWeather(completion:@escaping() -> Void) {
        let lat = LocationService.shared.latitude!
        let lon = LocationService.shared.longitude!
        print(lat)
        print(lon)
        
        let path = "https://api.weatherbit.io/v2.0/current?lat=\(lat)&lon=\(lon)&key=\(KeyCenter.key)&include=minutely"
        
        //Swift5부터 AF로 바뀜.
        AF.request(path).responseJSON { (response) in
            let result = response.result
            switch result {
            case .success(let value as [String: Any]):
                let json = JSON(value)
                let data = json["data"][0]
                self.city = data["city_name"].stringValue
                self.temp = data["temp"].double ?? 0.0
                self.weatherInfo = data["weather"]["description"].stringValue
                
                print(data["city_name"].stringValue)
                print(data["temp"].double ?? 0.0)
                print(data["weather"]["description"].stringValue)
                completion()
                
            case .failure(let error):
                print(error.localizedDescription)
            default:
                fatalError("received non-dictionary JSON response")
            }
        }
    }
}
