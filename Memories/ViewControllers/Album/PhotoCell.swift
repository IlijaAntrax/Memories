//
//  PhotoCell.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell
{
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        setupLoader()
        
        deleteBtn.isHidden = true
        
        self.imgView.contentMode = .scaleAspectFill
        
        self.loaderView.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
        self.imgView.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let key = keyPath
        {
            if key == "bounds"
            {
                if let imgView = object as? UIImageView
                {
                    if imgView == self.imgView
                    {
                        addMask()
                    }
                }
                else if let loader = object as? NVActivityIndicatorView
                {
                    if loader == loaderView
                    {
                        addLoaderMask()
                    }
                }
            }
        }
    }
    
    func addHandleGesture()
    {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        
        self.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer)
    {
        if sender.state == .began
        {
            //show delete button
        }
    }
    
    
    
    @IBAction func deleteBtnPressed(_ sender: Any)
    {
        //self.showDeleteAlert()
        //NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: NotificationDeletePhotoFromAlbum), object: photo, userInfo: nil)
    }
    
    var isDownloading = false
    
    var photo: Photo?
    {
        didSet
        {
            if let photo = self.photo
            {
                self.addMask()
                
                if let image = photo.img
                {
                    if photo.filter != .NoFilter
                    {
                        let img = FilterStore.filterImage(image: image, filterType: photo.filter, intensity: 0.5)
                        imgView.image = img
                    }
                    else
                    {
                        imgView.image = image
                    }
                    //imgView.layer.transform = self.photo?.transform ?? CATransform3DIdentity
                }
                else if !isDownloading
                {
                    if let url = photo.imgUrl
                    {
                        //download image
                        self.loaderView.startAnimating()
                        
                        self.isDownloading = true
                        
                        PhotoController.downloadImage(fromUrl: url) { (image) in
                            let img = FilterStore.filterImage(image: image, filterType: photo.filter, intensity: 0.5)
                            self.imgView.image = img
                            
                            self.photo?.img = image
                            
                            //self.imgView.layer.transform = self.photo?.transform ?? CATransform3DIdentity
                            
                            self.loaderView.stopAnimating()
                            
                            self.isDownloading = false
                        }
                    }
                }
            }
        }
    }
    
    func setupLoader()
    {
        loaderView.padding = self.imgView.frame.width / 5
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
            mask.frame = CGRect.init(x: 0.0, y: 0.0, width: imgView.frame.width, height: imgView.frame.height)
            loaderView.layer.mask = mask
        }
        else
        {
            loaderView.layer.mask?.frame = CGRect.init(x: 0.0, y: 0.0, width: imgView.frame.width, height: imgView.frame.height)
        }
    }
    
    
    func addMask()
    {
        if imgView.layer.mask == nil
        {
            let maskImg = UIImage(named: "photo_mask.png")!
            let mask = CALayer()
            mask.contents = maskImg.cgImage
            mask.frame = CGRect.init(x: 0.0, y: 0.0, width: imgView.frame.width, height: imgView.frame.height)
            imgView.layer.mask = mask
            imgView.layer.masksToBounds = true
        }
        else
        {
            imgView.layer.mask?.frame = CGRect.init(x: 0.0, y: 0.0, width: imgView.frame.width, height: imgView.frame.height)
        }
    }
}

class AddPhotosCell:UICollectionViewCell
{
    @IBOutlet weak var imgView: UIImageView!
}
