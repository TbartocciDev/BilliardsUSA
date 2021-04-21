//
//  HomeViewController.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 4/21/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    let imageArr = [UIImage(named: "billiards"), UIImage(named: "poolhall-dark"), UIImage(named: "poolplayer"), UIImage(named: "8ball")]
    
    var timer = Timer()
    var counter = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imagePageControl.currentPage = 0
        imagePageControl.numberOfPages = imageArr.count
        
//        DispatchQueue.main.async {
//            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeCollectionViewImage), userInfo: nil, repeats: true)
//        }
    }
    
    @objc func
    changeCollectionViewImage() {
//        let index = IndexPath.init(item: counter, section: 0)
        let imageRect = self.imageCollectionView.layoutAttributesForItem(at: IndexPath(row: counter, section: 0))?.frame
        
        if counter < imageArr.count - 1 {
            self.imageCollectionView.scrollRectToVisible(imageRect!, animated: true)
//            self.imageCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        } else {
            counter = 0
//            self.imageCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.imageCollectionView.scrollRectToVisible(imageRect!, animated: true)
        }
        imagePageControl.currentPage = counter
        print(counter)
//        imageCollectionView.reloadData()
    }
    
    
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        let image = imageArr[indexPath.row]!
        
        if let imageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell {
            
            imageCollectionViewCell.configureImage(with: image)
            
            cell = imageCollectionViewCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewSize = self.view.frame.size
        return viewSize
    }
    
    
    
    
    
    
}
