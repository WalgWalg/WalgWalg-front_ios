//
//  ParkView.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/06/29.
//

import UIKit
import MapKit
import CoreLocation
import CoreMotion

class WalkView: UIView, ComponentProductCellDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var ParkViewBtn: UIButton!
    
    @IBOutlet weak var WalkEndView: WalkEndView!
    @IBOutlet weak var WalkEndBtn: UIButton!
    @IBOutlet weak var parkViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var WalkEndViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var ParkCollectionView: UICollectionView!
    
    @IBOutlet weak var TimeIV: UIImageView!
    @IBOutlet weak var KcalIV: UIImageView!
    @IBOutlet weak var KmIV: UIImageView!
    @IBOutlet weak var WalkCountIV: UIImageView!
    @IBOutlet weak var WalkCountLabel: UILabel!
    @IBOutlet weak var KmLabel: UILabel!
    @IBOutlet weak var KcalLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!

    var mTimer : Timer?
    var number : Int = 0
    var previousCoordinate: CLLocationCoordinate2D?
    
    var parks:[Park] = []
    
    func selectedInfoBtn(index: Int) {
        // 선택된 index 값 알아
        print("selected cell : \(index)")
        
        // WalkEndView 띄워야해
        WalkEndView.visib = .visible
        ParkCollectionView.visib = .invisible
        
        // 초기화 후 데이터 불러오기
        setData()
        //walking start
        startWalking()
    }
    
    func setData() {
        // WalkEndView 값 셋팅
//        self.KmIV.image = UIImage(systemName: "icon_location")
//        
//        self.KcalIV.image = UIImage(systemName: "icon_kcal")
//        TimeIV.image = UIImage(systemName: "icon_time")
//        WalkCountIV.image = UIImage(systemName: "logo")
        self.WalkCountLabel.text = "0"
        self.KmLabel.text = "0"
        self.KcalLabel.text = "0"
        self.TimeLabel.text = "00:00"
    }
    
    func startWalking(){
        // 걷기 시작
//        self.WalkCountLabel.text = "\(HealthService.shared.StepCount)"
//        self.KmLabel.text = "\(HealthService.shared.Distance)"
//        self.KcalLabel.text = "\(HealthService.shared.Kcal)"
//        self.TimeLabel.text = "\(HealthService.shared.Time)"
    }
    
    func setupPark() {
        //        WalkEndViewConstraint.constant = 800
        WalkEndView.visib = .invisible
        print("setup Park in walkView")
        ParkCollectionView.register(UINib(nibName: "ParkCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ParkCollectionViewCell")
        ParkCollectionView.dataSource = self
        ParkCollectionView.delegate = self
    }
    
    @IBAction func WalkEndBtn(_ sender: Any) {
        // 산책 끝, 서버에 올려야함
        
        print("walk end step : \(HealthService.shared.StepCount)")
        print("walk end distance : \(HealthService.shared.Distance)")

    }
    
    @IBAction func WalkViewBtn(_ sender: Any) {
        if WalkEndViewConstraint.constant == 530 {
            WalkEndViewConstraint.constant = 750
        }
        else if WalkEndViewConstraint.constant == 750 {
            WalkEndViewConstraint.constant = 530
        }
    }
    
    @IBAction func parkViewBtn(_ sender: Any){
        if parkViewConstraint.constant == 530 {
            parkViewConstraint.constant = 750
        }
        else if parkViewConstraint.constant == 750 {
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
        
        ParkCell.index = indexPath.row
        ParkCell.delegate = self
        
        return ParkCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.ParkCollectionView.bounds.width * 0.7, height: self.ParkCollectionView.bounds.height/1.5)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last
        else {return}
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        if let previousCoordinate = self.previousCoordinate {
            var points: [CLLocationCoordinate2D] = []
            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
            let point2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            points.append(point1)
            points.append(point2)
            
            let lineDraw = MKPolyline(coordinates: points, count:points.count)
            MapView.addOverlay(lineDraw)
        }
        self.previousCoordinate = location.coordinate
    }
}

extension UIView {
    enum Visib {
        case visible
        case invisible
        case gone
    }
    
    var visib: Visib {
        get {
            let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
            if let constraint = constraint, constraint.isActive {
                return .gone
            } else {
                return self.isHidden ? .invisible : .visible
            }
        }
        set {
            if self.visib != newValue {
                self.setVisib(newValue)
            }
        }
    }
    private func setVisib(_ visibility: Visib) {
        let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
        
        switch visibility {
        case .visible:
            constraint?.isActive = false
            self.isHidden = false
            break
        case .invisible:
            constraint?.isActive = false
            self.isHidden = true
            break
        case .gone:
            if let constraint = constraint {
                constraint.isActive = true
            } else {
                let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
                self.addConstraint(constraint)
                constraint.isActive = true
            }
        }
    }
}


extension HomeStartViewController:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemYellow.withAlphaComponent(0.9)
            renderer.lineWidth = 7
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
}
