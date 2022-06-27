//
//  WeatherView.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/06/24.
//

import UIKit

class WeatherView: UIView {
    var currentWeather:CurrentWeather!
    var hourlyWeathers:[HourlyWeather] = []
    var weeklyWeathers:[WeeklyWeather] = []
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var weeklyCollectionView: UICollectionView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    func setupCurrentWeather() {
        print("test current city : \(currentWeather.city)")
        print("test current temp: \(currentWeather.temp)")
        print("test current weatherinfo: \(currentWeather.weatherInfo)")
        
        
        self.cityLabel.text = currentWeather.city
        self.tempLabel.text = "\(currentWeather.temp)"
        self.weatherInfoLabel.text = currentWeather.weatherInfo
        weeklyCollectionView.visibility = .invisible
        hourlyCollectionView.visibility = .visible
        setupHourlyCollectionView()
    }
    
    func setupHourlyCollectionView(){
        hourlyCollectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
    }
    
    func setupWeeklyCollectionView(){
        weeklyCollectionView.register(UINib(nibName: "WeeklyCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "WeeklyCollectionViewCell")
        weeklyCollectionView.dataSource = self
        weeklyCollectionView.delegate = self
    }
    
    func setupAll() {
        setupCurrentWeather()
//        setupHourlyCollectionView()
//        setupWeeklyCollectionView()
    }
    
    @IBAction func segmentControllClick(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // 오늘의 날씨
            weeklyCollectionView.visibility = .invisible
            hourlyCollectionView.visibility = .visible
            setupHourlyCollectionView()
        case 1 :
            // 주간 날씨
            hourlyCollectionView.visibility = .invisible
            weeklyCollectionView.visibility = .visible
            setupWeeklyCollectionView()
        default:
            break
        }
    }
}

extension UICollectionView {
    
    enum Visibility {
        case visible
        case invisible
        case gone
    }
    
    var visibility: Visibility {
        get {
            let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
            if let constraint = constraint, constraint.isActive {
                return .gone
            } else {
                return self.isHidden ? .invisible : .visible
            }
        }
        set {
            if self.visibility != newValue {
                self.setVisibility(newValue)
            }
        }
    }
    
    private func setVisibility(_ visibility: Visibility) {
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
extension WeatherView:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyCollectionView {
            return hourlyWeathers.count
        }
        else {
            return weeklyWeathers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyCollectionView {
            guard let Hourlycell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as? HourlyCollectionViewCell else {
                return UICollectionViewCell()
            }
            Hourlycell.generateCell(hourlyWeahter: hourlyWeathers[indexPath.item])
            return Hourlycell
        }
        else {
            guard let WeeklyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyCollectionViewCell", for: indexPath) as? WeeklyCollectionViewCell else {
                return UICollectionViewCell()
            }
            WeeklyCell.generateCell(weeklyWeather: weeklyWeathers[indexPath.item])
            return WeeklyCell
        }
    }
}
