//
//  GalleryCell.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var selectionImgView: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.photoView.contentMode = UIViewContentMode.scaleAspectFill
        self.selectionImgView.isHidden = true
    }
    
    func setupCell(withImage image: UIImage)
    {
        photoView.image = image
    }
    
    var isPictureSelected: Bool = false
    {
        didSet
        {
            if isPictureSelected
            {
                selectionImgView.isHidden = false
            }
            else
            {
                selectionImgView.isHidden = true
            }
        }
    }
}
