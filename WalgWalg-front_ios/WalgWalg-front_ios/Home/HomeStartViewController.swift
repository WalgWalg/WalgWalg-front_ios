//
//  HomeStartViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/30.
//

import UIKit
import CoreLocation
import MapKit

class HomeStartViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!
    var myLocations: [CLLocation] = []
    var walkView: UIView!
    var previousCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupWalkView()
        
        
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        
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
        let longtitude = location.coordinate.longitude
        
        if let previousCoordinate = self.previousCoordinate {
            var points: [CLLocationCoordinate2D] = []
            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
            let point2: CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(latitude, longtitude)
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
