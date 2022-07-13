//
//  RegisterViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/16.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var TFid: UITextField!
    @IBOutlet weak var TFpw: UITextField!
    @IBOutlet weak var TFcheckpw: UITextField!
    @IBOutlet weak var TFnickname: UITextField!
    @IBOutlet weak var TFaddress: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtn.layer.shadowColor = UIColor.black.cgColor // 색깔
        registerBtn.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        registerBtn.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        registerBtn.layer.shadowRadius = 2 // 반경
        registerBtn.layer.shadowOpacity = 0.2 // alpha값
        navigationItem.titleView?.tintColor = UIColor.systemYellow
        
        swipeRecognizer()
    }
    override func viewWillAppear(_ animated: Bool) {
        // 옵져버를 등록
        // 옵저버 대상 self
        // 옵져버 감지시 실행 함수
        // 옵져버가 감지할 것
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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

    @IBAction func post(_sender:Any){
        guard let strID = TFid.text, !strID.isEmpty else { return }
        guard let strPW = TFpw.text, !strPW.isEmpty else { return }
        guard let strCheckPW = TFcheckpw.text, !strCheckPW.isEmpty else { return }
        guard let strNick = TFnickname.text, !strNick.isEmpty else { return }
        guard let strAddr = TFaddress.text, !strAddr.isEmpty else { return }

        if strPW != strCheckPW {
            print("password is not same")
        }
        else{
            let url = URL(string: "http://ec2-15-165-129-147.ap-northeast-2.compute.amazonaws.com:8080/user/register")

            // URL 특수문자로 인한 인코딩
//            guard let encoded = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//            let url = URL(string: encoded)
            var request = URLRequest(url: url!)

            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 10

            // POST 로 보낼 정보
            let bodyParam = ["userid" : strID, "password" : strPW, "nickname" : strNick, "address" : strAddr]

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
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
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
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height + 60)
                }
            )
        }
    }

    @objc func keyboardDown() {
        self.view.transform = .identity
    }
    
    @objc func viewDidTap(gesture: UIGestureRecognizer){
        // editing 강제 멈춤 -> 키보드 내려감
        view.endEditing(true)
    }
}
