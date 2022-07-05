//
//  HomeStartViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/30.
//

import UIKit
import CoreLocation
import MapKit
import CoreMotion

class HomeStartViewController: UIViewController {
    
    var manager: CLLocationManager!
    var myLocations: [CLLocation] = []
    var previousCoordinate: CLLocationCoordinate2D?
    var locationManager:CLLocationManager?
    var walkView = Bundle.main.loadNibNamed("WalkView", owner: HomeStartViewController.self, options: nil)?.first as! WalkView
    var currentLocation:CLLocationCoordinate2D!
    
    var stringLocation: String? = ""
    
    
    let motionManager = CMMotionActivityManager()
    let pedometer = CMPedometer()

    var stepData = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAuthorization()
        setupWalkView()
        
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        
        walkView.MapView.mapType = MKMapType.standard
        // 지도에 내 위치 표시
        walkView.MapView.showsUserLocation = true
        // 현재 내 위치 기준으로 지도를 움직임.
        walkView.MapView.setUserTrackingMode(.follow, animated: true)
        
        walkView.MapView.isZoomEnabled = true
        walkView.MapView.delegate = self
        
        updateStep()
    }
    
    func updateStep() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.motionManager.startActivityUpdates(to: OperationQueue.main) { (data) in
                DispatchQueue.main.async {
                    if let activity = data {
                        if activity.running == true {
                            print("Running")
                        }
                        else if activity.walking == true {
                            print("Walking")
                        }
                        else if activity.automotive == true {
                            print("Automotive")
                        }
                    }
                }
            }
        }
        
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { (data, error) in
                if error == nil {
                    if let response = data {
                        DispatchQueue.main.async { [self] in
                            print("steps : \(response.numberOfSteps)")
                            print("startDate : \(response.startDate.time())")
                            print("endDate : \(response.endDate.timeIntervalSince(response.startDate))")
                            print("distance : \(response.distance!)")
                            guard let value = response.distance?.doubleValue else { return
                            }
                            let measurement = Measurement(value: value, unit: UnitLength.meters).converted(to: .kilometers)

                            let mf = MeasurementFormatter()
                            mf.unitOptions = .providedUnit
                            mf.unitStyle = .medium
                            mf.numberFormatter.maximumFractionDigits = 2
                            let startIndex = mf.string(from: measurement).index(mf.string(from: measurement).startIndex, offsetBy: 0)
                            let endIndex = mf.string(from: measurement).index(mf.string(from: measurement).startIndex, offsetBy: 4)
                            print(mf.string(from: measurement)[startIndex ..< endIndex])
                            let timeFloor = floor(response.endDate.timeIntervalSince(response.startDate))
                            let kcal = String(format: "%.3f", Double(truncating: response.numberOfSteps)/300)
                            print("\(kcal)")
                            
                            walkView.TimeLabel.text = "\(timeFloor.asString(style: .positional))"
                            walkView.WalkCountLabel.text = "\(response.numberOfSteps)"
                            walkView.KmLabel.text = "\(mf.string(from: measurement)[startIndex ..< endIndex])"
                            walkView.KcalLabel.text = "\(kcal)"
                            walkView.TimeIV.image = UIImage(systemName: "icon_time")
                            walkView.KmIV.image = UIImage(systemName: "icon_location")
                            walkView.KcalIV.image = UIImage(systemName: "icon_kcal")
                            walkView.WalkCountIV.image = UIImage(systemName: "logo")
                        }
                    }
                }
            }
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private func requestAuthorization() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            //정확도를 검사한다.
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            //앱을 사용할때 권한요청
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
            locationManagerDidChangeAuthorization(locationManager!)
        }else{
            print("authorization")
            //사용자의 위치가 바뀌고 있는지 확인하는 메소드
            locationManager!.startMonitoringSignificantLocationChanges()
        }
    }
    
    
    //    func configure() {
    //        print("Configure")
    //        if HKHealthStore.isHealthDataAvailable(){
    //            HealthService.shared.requestAuthorization()
    //        }
    //    }
    
    
    private func setupWalkView() {
        print("setup view")
        //        let walkView = Bundle.main.loadNibNamed("WalkView", owner: HomeStartViewController.self, options: nil)?.first as! WalkView
        walkView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        walkView.MapView.mapType = MKMapType.standard
        walkView.MapView.showsUserLocation = true
        walkView.MapView.setUserTrackingMode(.follow, animated: true)
        walkView.MapView.isZoomEnabled = true
        walkView.MapView.delegate = self
        
        walkView.ParkCollectionView.layer.cornerRadius = 30
        walkView.ParkCollectionView.layer.borderColor = UIColor.systemYellow.cgColor
        walkView.ParkCollectionView.layer.borderWidth = 2
        
        walkView.WalkEndView.layer.cornerRadius = 30
        walkView.WalkEndView.layer.borderColor = UIColor.systemYellow.cgColor
        walkView.WalkEndView.layer.borderWidth = 2
        
        getPark(walkView: walkView)
        walkView.setupPark()
        self.view.addSubview(walkView)
    }
    
    private func getPark(walkView:WalkView) {
        print("getPark()")
        Park.getParkInfo { (parks) in
            walkView.parks = parks
            walkView.ParkCollectionView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        guard let location = locations.last
    //        else {return}
    //        let latitude = location.coordinate.latitude
    //        let longitude = location.coordinate.longitude
    //
    //        if let previousCoordinate = self.previousCoordinate {
    //            var points: [CLLocationCoordinate2D] = []
    //            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
    //            let point2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
    //            points.append(point1)
    //            points.append(point2)
    //            let lineDraw = MKPolyline(coordinates: points, count:points.count)
    //            walkView.MapView.addOverlay(lineDraw)
    //        }
    //
    //        self.previousCoordinate = location.coordinate
    //    }
    //
    
    
    
}

extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = style
    guard let formattedString = formatter.string(from: self) else { return "" }
    return formattedString
  }
}

extension HomeStartViewController:CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            currentLocation = locationManager!.location?.coordinate
            print("current : \(String(describing: currentLocation))")
            print("current : \(currentLocation.latitude)")
            print("current : \(currentLocation.longitude)")
            
            LocationService.shared.longitude = currentLocation.longitude
            LocationService.shared.latitude = currentLocation.latitude
            print(LocationService.shared.latitude as Any)
            print(LocationService.shared.longitude as Any)
        }
    }
}

//extension HomeStartViewController:MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//
//        guard let polyLine = overlay as? MKPolyline
//        else {
//            print("can't draw polyline")
//            return MKOverlayRenderer()
//        }
//        let renderer = MKPolylineRenderer(polyline: polyLine)
//        renderer.strokeColor = .orange
//        renderer.lineWidth = 5.0
//        renderer.alpha = 1.0
//
//        return renderer
//    }
//
//}
