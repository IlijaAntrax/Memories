//
//  NewAlbumCell.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class NewAlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImgView: UIImageView!
    @IBOutlet weak var albumNameLbl:UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        albumNameLbl.font = Settings.sharedInstance.fontBoldSizeLarge()
        albumNameLbl.textColor = Settings.sharedInstance.grayDarkColor()
    }
    
    func setupDefault()
    {
        //self.albumImgView.image = Settings.sharedInstance.emptyAlbumImage()
        self.albumNameLbl.text = "Create album"
    }
    
    @IBAction func add(_ sender: Any)
    {
        addNew()
    }
    
    func addNew()
    {
        
    }}
