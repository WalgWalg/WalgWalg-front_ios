//
//  HomeStartViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/30.
//

import UIKit
import CoreLocation
import MapKit
import HealthKit

class HomeStartViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!, HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!])
    let share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!, HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!])
    
    var manager: CLLocationManager!
    var myLocations: [CLLocation] = []
    var walkView: UIView!
    var previousCoordinate: CLLocationCoordinate2D?
    
    var stringLocation: String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupWalkView()
        
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        
    }
    
    func configure() {
        print("Configure")
        if HKHealthStore.isHealthDataAvailable(){
            HealthService.shared.requestAuthorization()
        }
    }
    
    
    private func setupWalkView() {
        print("setup view")
        let walkView = Bundle.main.loadNibNamed("WalkView", owner: HomeStartViewController.self, options: nil)?.first as! WalkView
        walkView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        walkView.MapView.mapType = MKMapType.standard
        walkView.MapView.showsUserLocation = true
        walkView.MapView.setUserTrackingMode(.follow, animated: true)
        walkView.MapView.isZoomEnabled = true
        walkView.MapView.delegate = self
        
        walkView.ParkCollectionView.layer.cornerRadius = 30
        walkView.ParkCollectionView.layer.borderColor = UIColor.systemYellow.cgColor
        walkView.ParkCollectionView.layer.borderWidth = 2
        
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
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last
        else {return}
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr") // Korea
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { [self] (place, error) in
            let address = place! as [CLPlacemark]
            if address.count > 0 {
                let pm = place![0]
                if let lines = pm.addressDictionary?["FormattedAddressLines"] as? [String] {
                    let placeString = lines.joined(separator: ", ")
                    // Do your thing
                    print(placeString)
                    let splitString = placeString.components(separatedBy: " ")
                    print("(도) : \(splitString[0])")
                    print("(시) : \(splitString[1])")
                    print("(구) : \(splitString[2])")
                    print("(동) : \(splitString[3])")
                    LocationService.shared.city = splitString[0]
                    LocationService.shared.locality = splitString[1]
                    LocationService.shared.subLocality = splitString[2]
                    
                    print("test \(LocationService.shared.city as Any)")
                    print("test 1 \(LocationService.shared.locality as Any)")
                    print("test 2 \(LocationService.shared.subLocality as Any)")
                    stringLocation = "\(splitString[0]) \(splitString[1]) \(splitString[2])"
                    
                    LocationService.shared.stringAddress = stringLocation
                    
                    print("test location toString \(LocationService.shared.stringAddress as Any)")
                }
                
            }
            
            
            
        }
        if let previousCoordinate = self.previousCoordinate {
            var points: [CLLocationCoordinate2D] = []
            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
            let point2: CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(latitude, longitude)
            points.append(point1)
            points.append(point2)
            let lineDraw = MKPolyline(coordinates: points, count:points.count)
            //            Map.addOverlay(lineDraw)
        }
        
        self.previousCoordinate = location.coordinate
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        guard let polyLine = overlay as? MKPolyline
        else {
            print("can't draw polyline")
            return MKOverlayRenderer()
        }
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .orange
        renderer.lineWidth = 5.0
        renderer.alpha = 1.0
        
        return renderer
    }
    
    
}
