//
//  PhotoViewController.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var photoAlbum:PhotoAlbum?
    var photo:Photo?
    var selectedFilter = FilterType.NoFilter
    
    var editorImageView: EditorImageView!
    
    
    @IBOutlet weak var filtersCollection: UICollectionView!
    
    @IBOutlet weak var photoView: UIView!
    
    @IBOutlet weak var editorOptionsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = self.photo
        {
            let image = FilterStore.filterImage(image: photo.img, filterType: photo.filter, intensity: 0.5)
            
            let editorImgView = EditorImageView(image: image)
            editorImgView.initialPosition()
            editorImgView.hasScale = true
            editorImgView.hasRotate = true
            editorImgView.hasAutoAlign = true
            editorImgView.layer.transform = photo.transform
            //photoImgView.image = photo?.image
            
            editorImageView = editorImgView
        }
        
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(photoTransformed(_:)), name: NSNotification.Name.init(imageEditingEndedNotificaiton), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.filtersCollection.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        photoView.addSubview(editorImageView)
        editorImageView.initialPosition()
        editorImageView.layer.transform = self.photo!.transform
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let photo = self.photo {
            PhotoController.updatePhoto(photo, atAlbum: self.photoAlbum!)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Observer method
    @objc func photoTransformed(_ notification:NSNotification)
    {
        if let transform = notification.object as? CATransform3D
        {
            //update transform matrix to server
            photo?.transform = transform
            
            //photo?.updateTransformData()
        }
    }
    @IBAction func editorOptionsBtnPressed(_ sender: Any)
    {
        
    }
    
    @IBAction func resizeImageBtnPressed(_ sender: Any)
    {
        self.editorImageView.initalPositionAnimated()
        self.photo?.transform = CATransform3DIdentity
    }
    
    @IBAction func moreBtnPressed(_ sender: Any)
    {
        //Show popup with options delete and share
        let alert = UIAlertController(title: "More", message: "Choose action:", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Share photo", comment: ""), style: .default, handler: { _ in
            self.sharePhoto()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete photo", comment: "This will delete photo."), style: .default, handler: { _ in
            self.deletePhoto()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deletePhoto()
    {
        //show confirm alert
        let alert = UIAlertController(title: "Delete photo", message: "Are you sure that you want to delete this photo?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:{ (action) in
            self.deleteImage()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteImage()
    {
        PhotoController.deletePhoto(self.photo, fromAlbum: self.photoAlbum) { (success) in
            if success {
                self.photo = nil
                let deleteAlert = UIAlertController(title: "Alert", message: "Photo is deleted.", preferredStyle: .alert)
                deleteAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(deleteAlert, animated: true, completion: nil)
            }
            else {
                self.showErrorDialog()
            }
        }
    }
    
    func showErrorDialog()
    {
        let deleteAlert = UIAlertController(title: "Ops", message: "Something went wrong. Try again!", preferredStyle: .alert)
        deleteAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    func sharePhoto()
    {
        if let img = self.photo?.img
        {
            let activityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: {})
        }
    }
    
    //MARK: Collection view delegate, data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return FilterType.filtersNumber()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterImageCell", for: indexPath) as! FilterImageCell
        
        cell.setup(withImage: (photo?.img)!, filter: FilterType(rawValue: indexPath.item)!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.selectedFilter = FilterType(rawValue: indexPath.item)!
        editorImageView.image = FilterStore.filterImage(image: photo?.img, filterType: selectedFilter, intensity: 0.5)
        photo?.filter = self.selectedFilter
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.frame.height
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets.init(top: 0.0, left: editorOptionsBtn.frame.width, bottom: 0.0, right: 0.0)
    }
}
