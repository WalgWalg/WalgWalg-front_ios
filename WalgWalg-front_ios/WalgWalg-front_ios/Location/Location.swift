//
//  Location.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/07/08.
//

import Foundation
import Alamofire
import SwiftyJSON

class Location{
    
    var img: String = ""

    class func getLocationInfo(completion:@escaping([Location]) -> Void) {
        let address = LocationService.shared.stringAddress
        
        let path = "http://ec2-15-165-129-147.ap-northeast-2.compute.amazonaws.com:8080/board/region/경기도 용인시 기흥구"
        
        guard let encodedStr = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = URL(string: encodedStr)!
        // URL 특수문자로 인한 인코딩
        let header : HTTPHeaders = ["Content-Type": "application/json", "x-auth-token": LoginService.shared.accessToken!]
        
        AF.request(url,method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON { (response) in
            let result = response.result
            print("response result \(response.result)")
            var locations = [Location]()
            
            switch result {
            case .success(let value as [String:Any]):
                
                let json = JSON(value)
                let data = json["data"][0]
                self.city = data["city_name"].stringValue
                self.temp = data["temp"].double ?? 0.0
                self.weatherInfo = data["weather"]["description"].stringValue
                
                print(data["city_name"].stringValue)
                print(data["temp"].double ?? 0.0)
                print(data["weather"]["description"].stringValue)
                completion(locations)
                
            case .failure(let error):
                print(error.localizedDescription)
            default:
                fatalError("received non-dictionary JSON response")
            }
            //여기서 가져온 데이터를 자유롭게 활용하세요.
        }
    }
}

