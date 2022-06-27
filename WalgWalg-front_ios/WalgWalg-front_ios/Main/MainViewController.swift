//
//  ViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/10.
//

import UIKit
class MainViewController: UIViewController {

    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any add itional setup after loading the view.
        
        login.layer.shadowColor = UIColor.black.cgColor // 색깔
        login.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        login.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        login.layer.shadowRadius = 2 // 반경
        login.layer.shadowOpacity = 0.2 // alpha값

        
        register.layer.shadowColor = UIColor.black.cgColor // 색깔
        register.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        register.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        register.layer.shadowRadius = 2 // 반경
        register.layer.shadowOpacity = 0.2 // alpha값
        
    }

    
}

