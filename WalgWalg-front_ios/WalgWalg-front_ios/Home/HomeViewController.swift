//
//  HomeViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/16.
//

import UIKit
import FSCalendar
import CoreLocation

class HomeViewController: UIViewController{
    
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var weatherBtn: UIButton!
    @IBOutlet weak var count_view: UIView!
    @IBOutlet weak var start_btn: UIButton!
    
    var locationManager:CLLocationManager?
    var currentLocation:CLLocationCoordinate2D!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestAuthorization()
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
    
    
}

extension HomeViewController:CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            currentLocation = locationManager!.location?.coordinate
            print("current : \(String(describing: currentLocation))")
            print("current : \(currentLocation.latitude)")
            print("current : \(currentLocation.longitude)")
            
            LocationService.shared.longitude = currentLocation.longitude
            LocationService.shared.latitude = currentLocation.latitude
            let converter: LocationConverter = LocationConverter()
                    let (x, y): (Int, Int)
                        = converter.convertGrid(lon: LocationService.shared.longitude!, lat: LocationService.shared.latitude!)
                    
                    let findLocation: CLLocation = CLLocation(latitude: LocationService.shared.latitude!, longitude: LocationService.shared.longitude!)
                    let geoCoder: CLGeocoder = CLGeocoder()
                    let local: Locale = Locale(identifier: "Ko-kr") // Korea
                    geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
                        if let address: [CLPlacemark] = place {
                            print("(longitude, latitude) = (\(x), \(y))")
                            print("시(도): \(address.last?.administrativeArea)")
                            print("구(군): \(address.last?.locality)")
                            print("구(군): \(address.last?.subLocality)")
                            print("구(군): \(address.last?.country)")

                        }
                    }
            print(LocationService.shared.latitude as Any)
            print(LocationService.shared.longitude as Any)
        }
    }
}
