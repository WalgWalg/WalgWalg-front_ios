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
import SwiftyJSON
import Alamofire

class WalkView: UIView, ComponentProductCellDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var ParkViewBtn: UIButton!
    
    @IBOutlet weak var WalkEndView: UIView!
    @IBOutlet weak var WalkEndBtn: UIButton!
    @IBOutlet weak var ParkCollectionView: UICollectionView!
    
    @IBOutlet weak var parkViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var WalkEndViewConstraint: NSLayoutConstraint!
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
    
    var location:String = ""
    var address:String = ""
    var walkDate: String = ""
    var walkID: String = ""
    
    var previousCoordinate: CLLocationCoordinate2D?
    
    var parks:[Park] = []
    
    func selectedInfoBtn(index: Int) {
        // 선택된 index 값 알아
        print("selected cell : \(index)")
        print(parks[index])
        
        
        //"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let date = Date()
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            
            return dateFormatter
        }()

        location = parks[index].parkName
        address = parks[index].address
        walkDate = dateFormatter.string(from: date)
        
        
        print(dateFormatter.string(from: date))
                
        print("start walk")
        
        let url = URL(string:"http://ec2-15-165-129-147.ap-northeast-2.compute.amazonaws.com:8080/walk/start")
        
        let header : HTTPHeaders = ["Content-Type": "application/json", "x-auth-token": LoginService.shared.accessToken!]
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        request.headers = header
        
        request.timeoutInterval = 10
        
        let bodyParam = ["walkDate" : walkDate, "location" : location, "address" : address] as [String : Any]
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: bodyParam, options: [])
            print("request try catch")

        } catch {
            print("http Body Error")
        }
        
        AF.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON{ (response) in
                let result = response.result
                print("response result : \(result)")
                switch result {
                case .success(let value as [String: Any]):
                    let json = JSON(value)
                    let data = json["list"][0]
                    print(response.result)
                    self.walkID = data["walkId"].stringValue

                    print(data["walkId"].stringValue)
                    WalkIDService.shared.walkID = data["walkId"].stringValue
                    
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                    fatalError("received non-dictionary JSON response")
                }
            }

        // WalkEndView 띄워야해
        WalkEndView.visib = .visible
        ParkCollectionView.visib = .invisible
        
        // 초기화 후 데이터 불러오기
        setData()
        //walking start
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
        if WalkEndViewConstraint.constant == 549 {
            WalkEndViewConstraint.constant = 700
        }
        else if WalkEndViewConstraint.constant == 700 {
            WalkEndViewConstraint.constant = 549
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
