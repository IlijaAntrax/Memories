//
//  AlbumCell.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class AlbumCell: NewAlbumCell {
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var photosCountLbl:UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        albumImgView.contentMode = .scaleAspectFill
        
        photosCountLbl.font = Settings.sharedInstance.fontRegularSizeSmall()
        photosCountLbl.textColor = Settings.sharedInstance.grayLightColor()
        
        setupLoader()
        
        self.loaderView.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
        self.albumImgView.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let key = keyPath
        {
            if key == "bounds"
            {
                if let loader = object as? NVActivityIndicatorView
                {
                    if loader == loaderView
                    {
                        addLoaderMask()
                    }
                }
                else if let imgView = object as? UIImageView
                {
                    if imgView == self.albumImgView
                    {
                        addMask()
                    }
                }
            }
        }
    }
    
    var album:PhotoAlbum?
    {
        didSet
        {
            if let album = album
            {
                setup(album: album)
            }
        }
    }
    
    func setup(album: PhotoAlbum)
    {
        setAlbumImg()
        albumNameLbl.text = album.name
        photosCountLbl.text = String(album.photos.count) + " photos"
    }
    
    func setAlbumImg()
    {
        addLoaderMask()
        loaderView.startAnimating()
        
        albumImgView.image = album?.photos.first?.img
        
        if albumImgView.image == nil
        {
            if let firstPhoto = album?.photos.first
            {
                if let url = firstPhoto.imgUrl
                {
                    PhotoController.downloadImage(fromUrl: url) { (image) in
                        let img = FilterStore.filterImage(image: image, filterType: firstPhoto.filter, intensity: 0.5)
                        
                        self.albumImgView.image = img
                        
                        self.loaderView.stopAnimating()
                    }
                }
            }
            else
            {
                //TODO: set img holder for album image
                self.albumImgView.image = Settings.sharedInstance.emptyAlbumImage()
                self.loaderView.stopAnimating()
            }
        }
        else
        {
            self.loaderView.stopAnimating()
        }
    }
    
    func setupLoader()
    {
        loaderView.padding = self.albumImgView.frame.width / 5
        loaderView.color = Settings.sharedInstance.activityIndicatorColor()
        loaderView.backgroundColor = Settings.sharedInstance.activityIndicatorBgdColor()
    }
    
    func addLoaderMask()
    {
        if loaderView.layer.mask == nil
        {
            let maskImg = UIImage(named: "photo_mask.png")!
            let mask = CALayer()
            mask.contents = maskImg.cgImage
            mask.frame = CGRect.init(x: 0.0, y: 0.0, width: albumImgView.frame.width, height: albumImgView.frame.height)
            loaderView.layer.mask = mask
        }
        else
        {
            loaderView.layer.mask?.frame = CGRect.init(x: 0.0, y: 0.0, width: albumImgView.frame.width, height: albumImgView.frame.height)
        }
    }
    
    func addMask()
    {
        if albumImgView.layer.mask == nil
        {
            let maskImg = UIImage(named: "photo_mask.png")!
            let mask = CALayer()
            mask.contents = maskImg.cgImage
            mask.frame = CGRect.init(x: 0.0, y: 0.0, width: albumImgView.frame.width, height: albumImgView.frame.height)
            albumImgView.layer.mask = mask
            albumImgView.layer.masksToBounds = true
        }
        else
        {
            albumImgView.layer.mask?.frame = CGRect.init(x: 0.0, y: 0.0, width: albumImgView.frame.width, height: albumImgView.frame.height)
        }
    }
}
