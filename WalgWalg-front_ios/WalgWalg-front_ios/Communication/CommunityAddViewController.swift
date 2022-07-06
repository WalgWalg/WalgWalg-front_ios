//
//  CommunityAddViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/06/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class CommunityAddViewController: UIViewController {
    
    @IBOutlet weak var TFtitle: UITextField!
    @IBOutlet weak var TFhashtag: UITextField!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var complete: UIBarButtonItem!
    @IBOutlet weak var TFLocation: UITextField!
    @IBOutlet weak var TFContent: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func WriteComplete(_ sender: Any){
        guard let strTitle = TFtitle.text, !strTitle.isEmpty else { return }
        guard let strLocation = TFLocation.text, !strLocation.isEmpty else { return }
        guard let strContent = TFContent.text, !strContent.isEmpty else { return }
        guard let strHashtag = TFhashtag.text, !strHashtag.isEmpty else { return }
        
        let array = strHashtag.split(separator: " ")
        
        print("array check : \(array)")
        
        print(Date())
        
        
        let url = URL(string: "http://ec2-15-165-129-147.ap-northeast-2.compute.amazonaws.com:8080/board")
        
        //         URL 특수문자로 인한 인코딩
//        guard let encoded = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//        let url = URL(string: encoded)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(LoginService.shared.accessToken!, forHTTPHeaderField: "x-auth-token")

        request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        let bodyParam = ["walkId" : "0c908994-fc3f-4caf-bdb7-2bc005d6b815", "title" : strTitle, "hashTags" : array, "contents" : strContent] as [String : Any]
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: bodyParam, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { (response) in
            
            switch response.result {
            case .success:
                let statusCode = response.response?.statusCode
                if statusCode != 401 {
                    print("POST 성공")
                    print(response.result)
                    print(response)
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommunityViewController")
                    else{
                        return
                    }
                    vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                    self.present(vc, animated: true)
                }
                else{
                    print(response)
                    print("POST 실패")
                    
                }
                
            case .failure(let error):
                print("Alamofire Request Error\nCode:\(error._code), Message: \(error.localizedDescription)")
                
            }
            
        }
    }
    
}
