//
//  RecommendCollectionViewCell.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/06/14.
//

import UIKit

class CommunityCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var DateLB: UILabel!
    @IBOutlet weak var HashtagLB: UILabel!
    @IBOutlet weak var TitleLB: UILabel!
    @IBOutlet weak var mapIV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell(post:Post){
        print("generate Post Cell")
        DateLB.text = "\(post.date)"
        TitleLB.text = "\(post.title)"
        
        
        
    }
}
