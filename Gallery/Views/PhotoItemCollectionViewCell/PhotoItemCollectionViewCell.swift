//
//  PhotoItemCollectionViewCell.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import UIKit

class PhotoItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Private Properties
    
    private(set) var viewModel: PhotoItem?
    
    // MARK: - Public Methods
    
    func setup(viewModel: PhotoItem) {
        self.viewModel = viewModel
        
        MyFileManager.loadImage(by: viewModel.pathToPhoto) { [unowned self] image in
            imageView.image = image
        }
    }

}
