//
//  ImageCollectionViewCell.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 4/21/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    
    func configureImage(with image: UIImage) {
        imageView.image = image
    }
    
}
