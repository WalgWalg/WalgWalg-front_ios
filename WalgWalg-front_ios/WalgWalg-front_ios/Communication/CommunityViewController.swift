//
//  CommunityViewController.swift
//  WalgWalg-front_ios
//
//  Created by 강보현 on 2022/05/16.
//

import UIKit
import MaterialComponents.MaterialButtons


class CommunityViewController: UIViewController {
    
    // recommendcell 갯수 필요해서 img배열 대충 넣은거 - pager때문에
    var imgName = ["1", "2", "3", "4", "5"]

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
    
    @objc func tap(_ sender: Any){
        // floating Button 반응
        print("Hello World")
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        else{
            return
        }
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(vc, animated: true)
        
    }
    
    
    // 상단 collectionview 좋아요 수 추천 list
    @IBOutlet weak var RecommendCollectionView: UICollectionView!
    // 하단 collectionview 게시글 전체 list
    @IBOutlet weak var CommunityCollectionView: UICollectionView!
    // 상단 pager
    @IBOutlet weak var pager: UIPageControl!
    
    @IBAction func pageChanged(_ sender: UIPageControl){
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        // recommendCollectionView 가로 넘김 indexPath값
        RecommendCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFloatingButton()

        //  imgName 크기 만큼
        pager.numberOfPages = imgName.count
        pager.currentPage = 0
        
        //현재 페이지 pager색 노랑, 나머지 회색
        pager.pageIndicatorTintColor = UIColor.gray
        pager.currentPageIndicatorTintColor = UIColor.systemYellow
        // Do any additional setup after loading the view.
    }
}

extension CommunityViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width // 너비 저장
        let x = scrollView.contentOffset.x + (width/2.0)    // 현재 스크롤한 x좌표 저장
        
        let newPage = Int(x/width)
        if pager.currentPage != newPage {
            pager.currentPage = newPage
        }
    }
}

//extension CommunityViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: IndexPath) as? ListCell else {
//            return UICollectionViewCell()
//        }
//        let img = UIImage(named: "\imgName[indexPath.item]).jepg")
//        cell.imgView.image = img
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imgName.count
//    }
//}
//
//extension CommunityViewController: UICollectionViewFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return collectionView.bounds.size
//    }
//}
//
//class ListCell: UICollectionViewCell {
//    @IBOutlet weak var imgView: UIImageView!
//}
