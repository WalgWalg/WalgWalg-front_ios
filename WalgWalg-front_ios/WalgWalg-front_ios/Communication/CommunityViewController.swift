//
//  CommunityViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/16.
//

import UIKit
import MaterialComponents.MaterialButtons


class CommunityViewController: UIViewController {
    var posts:[Post] = []
    @IBOutlet weak var detailAddressLB: UILabel!
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFloatingButton()
        Post.getPostInfo { (posts) in
            self.posts = posts
            self.postCollectionView.reloadData()
        }
        
        setupCommunityCollectionView()

        detailAddressLB.text = "\(LocationService.shared.stringAddress ?? "경기도 용인시 기흥구")"
    }

    func setupCommunityCollectionView(){
        postCollectionView.register(UINib(nibName: "CommunityCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CommunityCollectionViewCell")
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        
    }
    
    @objc func tap(_ sender: Any){
        // floating Button 반응
        print("Hello World")
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommunityAddViewController")
        else{
            return
        }
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(vc, animated: true)
        
    }
    
    func setFloatingButton(){
        let floatingButton = MDCFloatingButton()
        let image = UIImage(systemName: "logo.fill")
        floatingButton.sizeToFit()
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.setImage(image, for: .normal)
        floatingButton.setImageTintColor(.white, for: .normal)
        floatingButton.backgroundColor = .systemYellow
        floatingButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        view.addSubview(floatingButton)
        view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -100))
        view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -30))
    }
    
}

extension CommunityViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityCollectionViewCell", for: indexPath) as? CommunityCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.generateCell(post: posts[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
}

//extension CommunityViewController: UICollectionViewFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return collectionView.bounds.size
//    }
//}
//
//class ListCell: UICollectionViewCell {
//    @IBOutlet weak var imgView: UIImageView!
//}
