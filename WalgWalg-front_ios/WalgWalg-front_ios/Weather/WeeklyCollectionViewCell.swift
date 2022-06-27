//
//  WeelkelyCollectionViewCell.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/06/24.
//

import UIKit

class WeeklyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weekLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell(weeklyWeather:WeeklyWeather) {
        let str = weeklyWeather.date
        let startIdx:String.Index = str.index(str.startIndex, offsetBy: 5)
        print("\(str[startIdx...])")
        weekLabel.text = "\(str[startIdx...])"
        weatherImage.image = getWeatherIconFor(weeklyWeather.weatherIcon)
        weatherImage.sizeToFit()
        tempLabel.text = "\(weeklyWeather.temp)"
    }
}
