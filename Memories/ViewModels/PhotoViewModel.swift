//
//  PhotoViewModel.swift
//  Memories
//
//  Created by Ilija Antonjevic on 30/05/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewModel:ViewModelDelegate
{
    private let photo:Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    private var isDownloading = false
    
    func configure(_ cell: UICollectionViewCell) {
        if let cell = cell as? PhotoCell {
            
            cell.addMask()
            
            if let image = photo.img
            {
                if photo.filter != .NoFilter
                {
                    let img = FilterStore.filterImage(image: image, filterType: photo.filter, intensity: 0.5)
                    cell.imgView.image = img
                }
                else
                {
                    cell.imgView.image = image
                }
            }
            else if !isDownloading
            {
                if let url = photo.imgUrl
                {
                    //download image
                    cell.loaderView.startAnimating()
                    
                    self.isDownloading = true
                    
                    PhotoController.downloadImage(fromUrl: url) { (image) in
                        let img = FilterStore.filterImage(image: image, filterType: self.photo.filter, intensity: 0.5)
                        
                        cell.imgView.image = img
                        self.photo.img = image
                        
                        cell.loaderView.stopAnimating()
                        self.isDownloading = false
                    }
                }
            }
        }
    }
    
    func saveData() {
        //No implementation
    }
    
    func loadData() {
        //No implementation
    }
}
