//
//  PhotosCollectionViewCell.swift
//  FileManager
//
//  Created by Chinmoy Biswas on 8/3/22.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bacView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelecte {
                self.bacView.backgroundColor = isSelected ? .orange : .clear
            } else {
                self.bacView.backgroundColor = .clear
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 5
    }

}
