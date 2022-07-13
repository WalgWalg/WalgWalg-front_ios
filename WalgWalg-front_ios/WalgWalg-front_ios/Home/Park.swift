//
//  Park.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/06/29.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreLocation

class Park{
    var address:String = ""
    var parkName:String = ""
    var lat:Double = 0.0
    var lon:Double = 0.0
    var currentAddress : [String] = []
    
    init(parkDictionary:Dictionary<String,Any>) {
        let data = JSON(parkDictionary)
        self.address = data["numberAddress"].stringValue
        self.parkName = data["parkName"].stringValue
        self.lat = data["latitude"].double ?? 0.0
        self.lon = data["longitude"].double ?? 0.0
    }
    
    class func getParkInfo(completion:@escaping([Park]) -> Void) {
        let address = LocationService.shared.stringAddress!
        
        print("get Park address : \(address)")
        
        let path = "http://ec2-15-165-129-147.ap-northeast-2.compute.amazonaws.com:8080/park/경기도 용인시 기흥구"
        guard let encodedStr = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        let url = URL(string: encodedStr)!
        // URL 특수문자로 인한 인코딩
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url,method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON { (response) in
            let result = response.result
            
            var parks = [Park]()
            
            switch result {
            case .success(let value as [String:Any]):
                
                if let data = value["list"] as? [Dictionary<String,AnyObject>] {
                    
                    print("test \(data.count)")
                    data.forEach{
                        parks.append(Park(parkDictionary: $0))
                    }
                }
                print("print park : \(parks.count)")
                completion(parks)
                
            case .failure(let error):
                print(error.localizedDescription)
                
            default:
                fatalError()
            }
            //여기서 가져온 데이터를 자유롭게 활용하세요.
        }
    }
}
