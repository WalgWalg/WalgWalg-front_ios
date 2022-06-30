//
//  ParkView.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/06/29.
//

import UIKit
import MapKit
import CoreLocation
class WalkView: UIView {
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var ParkViewBtn: UIButton!
    
    @IBOutlet weak var WalkEndViewConstraintBtn: UIButton!
    @IBOutlet weak var WalkEndBtn: UIButton!
    @IBOutlet weak var parkViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var ParkCollectionView: UICollectionView!
    
    var parks:[Park] = []
    
    func setupPark() {
        print("setup Park in walkView")
        ParkCollectionView.register(UINib(nibName: "ParkCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ParkCollectionViewCell")
        ParkCollectionView.dataSource = self
        ParkCollectionView.delegate = self
        
        
    }
    
    @IBAction func parkViewBtn(_ sender: Any){
        if parkViewConstraint.constant == 530 {
            parkViewConstraint.constant = 770
        }
        else if parkViewConstraint.constant == 770 {
            parkViewConstraint.constant = 530
        }
    }
}

extension WalkView:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("park count : \(parks.count)")
        return parks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let ParkCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParkCollectionViewCell", for: indexPath) as? ParkCollectionViewCell else {
            return UICollectionViewCell()
        }
        ParkCell.generateCell(park: parks[indexPath.item])
        return ParkCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.ParkCollectionView.bounds.width * 0.7, height: self.ParkCollectionView.bounds.height/2)


    }
}
