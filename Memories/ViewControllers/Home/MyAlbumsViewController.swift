//
//  MyAlbumsViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/11/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit
import FirebaseAuth

class MyAlbumsViewController: HomeViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        super.albumsInterface = MyAlbumsStrategy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.albumsInterface = MyAlbumsStrategy()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.albumsCollection.reloadItems(at: [IndexPath(row: 0, section: 0)])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Collection delegate
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.item == 0 // profile cell
        {
            let profileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileCell", for: indexPath) as? UserProfileCell
            
            profileCell?.myProfileHeaderView.setup(withDelegate: self, andUser: MyAccount.sharedInstance.myUser)
            profileCell?.myProfileHeaderView.uploadImgBtn.isHidden = true
            
            return profileCell!
        }
        else
        {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }

}
