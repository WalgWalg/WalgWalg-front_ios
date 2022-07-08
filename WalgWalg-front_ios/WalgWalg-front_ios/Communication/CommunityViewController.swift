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
    var ranks:[Rank] = []
    
    @IBOutlet weak var detailAddressLB: UILabel!
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var rankCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankCollectionView.layer.cornerRadius = 10
        
        setFloatingButton()
        Post.getPostInfo { (posts) in
            print(posts.count)
            self.posts = posts
            self.postCollectionView.reloadData()
        }
        Rank.getRankInfo { (ranks) in
            print(ranks.count)
            self.ranks = ranks
            self.rankCollectionView.reloadData()
        }
        
        setupCommunityCollectionView()
        setupRankCollectionView()
        detailAddressLB.text = "\(LocationService.shared.stringAddress ?? "경기도 용인시 기흥구")"
    }
    
    func setupCommunityCollectionView(){
        postCollectionView.register(UINib(nibName: "CommunityCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CommunityCollectionViewCell")
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        
    }
    
    func setupRankCollectionView(){
        rankCollectionView.register(UINib(nibName: "RankCollectionView", bundle: Bundle.main), forCellWithReuseIdentifier: "RankCollectionView")
        rankCollectionView.dataSource = self
        rankCollectionView.delegate = self
        
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
        
        if collectionView == postCollectionView {
            guard let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityCollectionViewCell", for: indexPath) as? CommunityCollectionViewCell else {
                return UICollectionViewCell()
            }
            postCell.generateCell(post: posts[indexPath.item])
            return postCell
        }
        else{
            guard let rankCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankCollectionViewCell", for: indexPath) as? RankCollectionViewCell else {
                return UICollectionViewCell()
            }
            rankCell.generateCell(rank: ranks[indexPath.item])
            return rankCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == postCollectionView {
            return posts.count
        }
        else {
            return ranks.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let cellWidth = width/2
        let cellHeight = height/2
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
}
