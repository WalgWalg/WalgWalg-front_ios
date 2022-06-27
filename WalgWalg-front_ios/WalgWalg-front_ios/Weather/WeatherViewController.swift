//
//  WeatherViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/30.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController{
    var temperature: Double = 0.0
    var icon: String = ""
    var locationManager:CLLocationManager?
    var currentLocation:CLLocationCoordinate2D!
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization()
        setupWeatherView()
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
            //사용자의 위치가 바뀌고 있는지 확인하는 메소드
            locationManager!.startMonitoringSignificantLocationChanges()
        }
    }
    private func setupWeatherView() {
        print("setup view")
        let weatherView = Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)?.first as! WeatherView
        weatherView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        getCurrentWeather(weatherView: weatherView)
        getHourlyWeather(weatherView: weatherView)
        getWeeklyWeather(weatherView: weatherView)
        self.view.addSubview(weatherView)
    }

    private func getCurrentWeather(weatherView:WeatherView) {
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather {
            weatherView.setupAll()
        }
    }

    private func getWeeklyWeather(weatherView:WeatherView) {
        WeeklyWeather.getWeeklyWeather { (weeklyWeathers) in
            weatherView.weeklyWeathers = weeklyWeathers
            weatherView.weeklyCollectionView.reloadData()
        }
    }

    private func getHourlyWeather(weatherView:WeatherView) {
        HourlyWeather.getHourlyWeather { (hourlyWeathers) in
            weatherView.hourlyWeathers = hourlyWeathers
            weatherView.hourlyCollectionView.reloadData()
        }
    }
    
}

extension WeatherViewController:CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate
            LocationService.shared.longitude = currentLocation.longitude
            LocationService.shared.latitude = currentLocation.latitude
            print(LocationService.shared.latitude as Any)
            print(LocationService.shared.longitude as Any)
        }
    }
}
extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: collectionView.frame.height)
    }
}
