//
//  SharedAlbumsViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/11/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class SharedAlbumsViewController: HomeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func loadAlbum(completionHandler: @escaping ([PhotoAlbum]) -> ()) {
        PhotoAlbumController.getSharedAlbums(forUserId: MyAccount.sharedInstance.userId ?? "") { (albums) in
            completionHandler(albums)
        }
    }

    //MARK: CollectionView delegate, data source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.albums.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let sharedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SharedAlbumCell", for: indexPath) as? SharedAlbumCell
        
        sharedCell?.album = self.albums[indexPath.item]
        
        return sharedCell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.showAlbumVC(forIndex: indexPath.row)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let insset = collectionView.frame.width * 0.02
        let offsets = 2.0 * insset + 2.0 * insset
        let width = (collectionView.frame.width - offsets) * 0.33
        let height = width * 500 / 400
        
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return collectionView.frame.width * 0.02
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return collectionView.frame.width * 0.02
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let insset:CGFloat = collectionView.frame.width * 0.02
        
        return UIEdgeInsets.init(top: insset, left: insset, bottom: 0.0, right: insset)
    }
}
