//
//  SharedAlbumCell.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class SharedAlbumCell: AlbumCell {
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        albumNameLbl.font = Settings.sharedInstance.fontBoldSizeMedium()
        albumNameLbl.textColor = Settings.sharedInstance.grayDarkColor()
        albumNameLbl.adjustsFontSizeToFitWidth = true
    }
    
    override func setup(album: PhotoAlbum)
    {
        super.setup(album: album)
        
        photosCountLbl.isHidden = true
        
        super.addMask()
    }
}
