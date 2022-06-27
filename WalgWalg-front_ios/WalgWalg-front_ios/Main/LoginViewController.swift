//
//  LoginViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/16.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var TFpw: UITextField!
    @IBOutlet weak var TFid: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login.layer.shadowColor = UIColor.black.cgColor // 색깔
        login.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        login.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        login.layer.shadowRadius = 2 // 반경
        login.layer.shadowOpacity = 0.2 // alpha값
        
        swipeRecognizer()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_sender:Any){
        //        guard let strID = TFid.text, !strID.isEmpty else { return }
        //        guard let strPW = TFpw.text, !strPW.isEmpty else { return }
        //
        //        let url = URL(string: "http://ec2-15-165-129-147.ap-northeast-2.compute.amazonaws.com:8080/user/login")
        //
        //        var request = URLRequest(url: url!)
        //
        //        request.httpMethod = "POST"
        //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.timeoutInterval = 10
        //
        //        // POST 로 보낼 정보
        //        let bodyParam = ["userid" : strID, "password" : strPW]
        //
        //        // httpBody 에 parameters 추가
        //        do {
        //            try request.httpBody = JSONSerialization.data(withJSONObject: bodyParam, options: [])
        //        } catch {
        //            print("http Body Error")
        //        }
        //
        //        Alamofire.request(request).responseString { (response) in
        //
        //            switch response.result {
        //            case .success:
        //                let statusCode = response.response?.statusCode
        //                if statusCode != 401 {
        //                    print("POST 성공")
        //                    print(response.result)
        //                    print(response)
        //                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        //                    else{
        //                        return
        //                    }
        //                    vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        //                    self.present(vc, animated: true)
        //                }
        //                else{
        //                    print(response)
        //                    print("POST 실패")
        //
        //                }
        //
        //            case .failure(let error):
        //                print("Alamofire Request Error\nCode:\(error._code), Message: \(error.localizedDescription)")
        //
        //            }
        //        }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        else{
            return
        }
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(vc, animated: true)
    }
    
    func swipeRecognizer(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesuture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesuture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                self.dismiss(animated: true, completion: nil)
            default: break
            }
        }
    }
    
}
