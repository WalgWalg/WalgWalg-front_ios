//
//  LocationViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/16.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var Locationaddress: UILabel!
    @IBOutlet weak var LocationCollectionView: UICollectionView!
    
    var locations:[Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
