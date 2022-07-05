//
//  ParkCollectionViewCell.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/06/29.
//

import UIKit

protocol ComponentProductCellDelegate {
    func selectedInfoBtn(index: Int)
}

class ParkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var parkAddressLB: UILabel!
    @IBOutlet weak var parkNameLB: UILabel!
    
    var index: Int = 0
    var delegate: ComponentProductCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell(park:Park) {
        print("generateCell")
        print("generateCell : \(park.parkName)")
        
        startBtn.layer.shadowColor = UIColor.black.cgColor
        startBtn.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        startBtn.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        startBtn.layer.shadowRadius = 2 // 반경
        startBtn.layer.shadowOpacity = 0.2 // alpha값
        parkAddressLB.text = "\(park.address)"
        parkNameLB.text = "\(park.parkName)"
        
    }
    
    @IBAction func selectedInfoBtn(_ sender: Any) {
        self.delegate?.selectedInfoBtn(index: index)
        print("selected cell 2 : \(index)")

    }



}
