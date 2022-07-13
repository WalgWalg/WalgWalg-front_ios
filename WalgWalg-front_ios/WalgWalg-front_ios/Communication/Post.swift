//
//  Post.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/07/06.
//

import Foundation
import SwiftyJSON
import Alamofire

class Post{
    var address : String = ""
    var title : String = ""
    var date : String = ""
//    var contents : String = ""
    var hashTags : [String] = []
//    var course : String = ""
    var likes : Int = 0
    var img : String = ""
    
    init(postDictionary:Dictionary<String,Any>) {
        let data = JSON(postDictionary)
        self.title = data["title"].stringValue
//        self.contents = data["contents"].stringValue
//        self.hashTags = data["hashTags"]
        self.date = data["date"].stringValue
//        self.course = data["course"].stringValue
        self.likes = data["likes"].intValue
        print("post boardId : \(data["boardId"].stringValue)")
        self.img = data["course"].stringValue
        
    }
    
    class func getPostInfo(completion:@escaping([Post]) -> Void) {
        let address = LocationService.shared.stringAddress
        
        print("getParkInfo 2 : \(address ?? "경기도 용인시 기흥구")")
        print("getParkInfo 2 : \(LoginService.shared.accessToken)")
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
            var posts = [Post]()
            
            switch result {
            case .success(let value as [String:Any]):
                
                if let data = value["list"] as? [Dictionary<String,AnyObject>] {
                    
                    print("test \(data.count)")
                    data.forEach{
                        posts.append(Post(postDictionary: $0))
                    }
                    
                }
                print("print posts: \(posts.count)")
                completion(posts)
                
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
