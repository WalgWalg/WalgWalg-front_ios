//
//  HomeViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/16.
//

import UIKit
import FSCalendar

class HomeViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var weatherBtn: UIButton!
    @IBOutlet weak var count_view: UIView!
    @IBOutlet weak var start_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView()
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                          y: 0,
                                                          width: 10, height: 10)).cgPath
        view.layer.shouldRasterize = true
        
        count_view.layer.shadowColor = UIColor.black.cgColor
        count_view.layer.masksToBounds = false
        count_view.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        count_view.layer.shadowRadius = 2 // 반경
        count_view.layer.shadowOpacity = 0.2 // alpha값
        count_view.layer.cornerRadius = 30
        start_btn.layer.shadowColor = UIColor.black.cgColor // 색깔
        start_btn.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        start_btn.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        start_btn.layer.shadowRadius = 2 // 반경
        start_btn.layer.shadowOpacity = 0.2 // alpha값
        // Do any additional setup after loading the view.
    }
}
