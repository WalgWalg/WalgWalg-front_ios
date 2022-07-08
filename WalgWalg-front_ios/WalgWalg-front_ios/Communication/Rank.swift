//
//  Favorite.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/07/08.
//

import Foundation
import Alamofire
import SwiftyJSON

class Rank {
    
    var parkName : String = ""
    var parkImg: String = ""
    init(rankDictionary:Dictionary<String,Any>) {
        let data = JSON(rankDictionary)
        self.parkImg = data["image"].stringValue
        self.parkName = data["parkName"].stringValue
    }
    
    class func getRankInfo(completion:@escaping([Rank]) -> Void) {
        let path = "http://ec2-15-165-129-147.ap-northeast-2.compute.amazonaws.com:8080//board/top"

        let header : HTTPHeaders = ["Content-Type": "application/json", "x-auth-token": LoginService.shared.accessToken!]
        AF.request(path,method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON { (response) in
            let result = response.result
            print("response result \(response.result)")
            var ranks = [Rank]()
            
            switch result {
            case .success(let value as [String:Any]):
                
                if let data = value["list"] as? [Dictionary<String,AnyObject>] {
                    
                    print("test \(data.count)")
                    data.forEach{
                        ranks.append(Rank(rankDictionary: $0))
                    }
                }
                print("print ranks: \(ranks.count)")
                completion(ranks)
                
            case .failure(let error):
                print("Post error")
                print(error.localizedDescription)
                
            default:
                fatalError()
            }
            //여기서 가져온 데이터를 자유롭게 활용하세요.
        }
    }
}
