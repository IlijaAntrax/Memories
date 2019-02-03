//
//  GalleryViewController.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit
import Photos
import FirebaseStorage

private let reuseIdentifier = "Cell"

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    private let cellsInRow:Int = 4
    private let insetOffset:CGFloat = 2.0
    
    var photoAlbum:PhotoAlbum?
    
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult<PHAsset>!
    var assetThumbnailSize: CGSize!
    var requestOptions: PHImageRequestOptions!
    
    var selectedImageIndexes: [Int] = [Int]()
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    var doneBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        addDoneBtn()
        
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
        setupAssetCollcetion()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        fetchPhotosFromAssetCollection()
    }
    
    func addDoneBtn()
    {
        let btnWidth = (navigationController?.navigationBar.frame.height)!
        doneBtn = UIButton(type: .custom)
        doneBtn.frame = CGRect(x: 0.0, y: 0.0, width: btnWidth, height: btnWidth)
        doneBtn.setBackgroundImage(UIImage(named: "done.png"), for: .normal)
        doneBtn.addTarget(self, action: #selector(addPhotosAction), for: .touchUpInside)
        
        let doneBarItem = UIBarButtonItem(customView: doneBtn)
        let currWidth = doneBarItem.customView?.widthAnchor.constraint(equalToConstant: btnWidth)
        currWidth?.isActive = true
        let currHeight = doneBarItem.customView?.heightAnchor.constraint(equalToConstant: btnWidth)
        currHeight?.isActive = true
        
        self.navigationItem.rightBarButtonItem = doneBarItem
    }
    
    func setupAssetCollcetion()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                let fetchOptions = PHFetchOptions()
                
                let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                
                if let first_Obj:AnyObject = collection.firstObject
                {
                    //found the album
                    self.assetCollection = first_Obj as? PHAssetCollection
                }
            } else {
                //TODO: Show allert
            }
        }
    }
    
    func fetchPhotosFromAssetCollection()
    {
        if let cellSize = (galleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize
        {
            self.assetThumbnailSize = CGSize(width: cellSize.width * 4.0, height: cellSize.height * 4.0)
        }
        
        self.requestOptions = PHImageRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.resizeMode = .fast
        requestOptions.deliveryMode = .highQualityFormat
        
        //fetch the photos from collection
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.photosAsset = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        self.galleryCollectionView.reloadData()
    }
    
    //MARK: fecth photos from gallery
    private var galleryImageSize = CGSize()
    private var imagesFromGallery = [UIImage]()
    
    func prepareOptionsForFecthing()
    {
        
    }
    
    //MARK: Activity loader
    var activityIndicatorView:NVActivityIndicatorView?
    
    func showLoader()
    {
        let frame = self.galleryCollectionView.frame
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: NVActivityIndicatorType.ballPulseSync)
        
        activityIndicatorView?.padding = self.galleryCollectionView.frame.width / 4
        activityIndicatorView?.color = Settings.sharedInstance.activityIndicatorColor()
        activityIndicatorView?.backgroundColor = Settings.sharedInstance.activityIndicatorBgdColor()
        
        self.galleryCollectionView.superview?.addSubview(activityIndicatorView!)
        activityIndicatorView?.startAnimating()
    }
    
    func hideLoader()
    {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.removeFromSuperview()
    }
    
    @objc func addPhotosAction()
    {
        let dispacthGroup = DispatchGroup()
        
        self.showLoader()
        
        for index in selectedImageIndexes
        {
            dispacthGroup.enter()
            
            let imageQueue = DispatchQueue(label: "assetAppendQueue_" + String(index))
            imageQueue.async {
                
                let asset: PHAsset = self.photosAsset[index]
                
                let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                print(size)
                
                PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.default, options: self.requestOptions, resultHandler: {(result, info)in
                    if let image = result
                    {
                        PhotoController.uploadAlbumImage(image: image) { (photoUrl) in
                            let photo = Photo.init(withID: "", imgUrl: photoUrl?.absoluteString ?? "", transform: CATransform3DIdentity, filter: FilterType.NoFilter.rawValue)
                            photo.img = image
                            self.photoAlbum?.photos.append(photo)
                            PhotoController.addPhotoToAlbum(photo: photo, album: self.photoAlbum!)
                            dispacthGroup.leave()
                        }
                    }
                })
                
            }
        }
        
        dispacthGroup.notify(queue: DispatchQueue.main) {
            self.hideLoader()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //MARK: CollectionView delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.photosAsset != nil
        {
            return self.photosAsset.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        
        let asset: PHAsset = self.photosAsset[indexPath.item]
        
        PHImageManager.default().requestImage(for: asset, targetSize: self.assetThumbnailSize, contentMode: .aspectFill, options: requestOptions, resultHandler: {(result, info)in
            if result != nil {
                cell.photoView.image = result
                cell.isPictureSelected = self.selectedImageIndexes.contains(indexPath.row)
            }
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(indexPath)
        if let cell = collectionView.cellForItem(at: indexPath) as? GalleryCell
        {
            cell.isPictureSelected = !cell.isPictureSelected
            
            if selectedImageIndexes.contains(indexPath.row)
            {
                selectedImageIndexes.remove(at: selectedImageIndexes.index(of: indexPath.row)!)
            }
            else
            {
                selectedImageIndexes.append(indexPath.row)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (collectionView.frame.width - (CGFloat(cellsInRow) + 1) * insetOffset) / CGFloat(cellsInRow)
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return insetOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return insetOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets.init(top: 0.0, left: insetOffset, bottom: 0.0, right: insetOffset)
    }
}
