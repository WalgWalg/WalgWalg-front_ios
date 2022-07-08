//
//  FavoriteCollectionViewCell.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/07/06.
//

import UIKit

class RankCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var RankParkNameLB: UILabel!
    @IBOutlet weak var RankParkIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell(rank:Rank){
        print("generate Rank Cell")
        RankParkNameLB.text = "\(rank.parkName)"
        if let url = URL(string: rank.parkImg){
            URLSession.shared.dataTask(with: url){
                [weak self] data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self?.RankParkIV.image = UIImage(data: data)
                    }
                }
            }.resume()
            
        }
    }
}

