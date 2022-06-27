//
//  HomeStartViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/30.
//

import UIKit

class HomeStartViewController: UIViewController {

    @IBOutlet weak var recommandView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recommandView.layer.cornerRadius = 30
        recommandView.layer.borderColor = UIColor.systemYellow.cgColor
        recommandView.layer.borderWidth = 1
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
