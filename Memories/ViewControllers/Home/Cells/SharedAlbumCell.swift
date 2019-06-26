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
        
        photosCountLbl.isHidden = true
        
        albumNameLbl.font = Settings.sharedInstance.fontBoldSizeSmall()
        albumNameLbl.textColor = Settings.sharedInstance.grayDarkColor()
    }
}
