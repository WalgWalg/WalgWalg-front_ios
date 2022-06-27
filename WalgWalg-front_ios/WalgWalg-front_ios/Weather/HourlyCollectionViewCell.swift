//
//  HourlyCollectionViewCell.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/06/24.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func generateCell(hourlyWeahter:HourlyWeather){
        tempLabel.text = "\(hourlyWeahter.temp)"
        timeLabel.text = hourlyWeahter.date
        weatherImage.image = getWeatherIconFor(hourlyWeahter.weatherIcon)
    }
}

