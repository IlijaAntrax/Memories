//
//  SearchAccountViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/11/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class SearchAccountViewController: KeyboardViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var searchTxtField: UITextField!
    
    @IBOutlet weak var usersCollection: UICollectionView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private var usersList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchTxtField.delegate = self
        self.searchTxtField.font = Settings.sharedInstance.fontRegularSizeMedium()
        
        self.usersCollection.delegate = self
        self.usersCollection.dataSource = self
        
        self.loader.isHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchUsersBy(name: String)
    {
        self.usersList.removeAll()
        self.usersCollection.reloadData()
        
        if name != ""
        {
            self.loader.isHidden = false
            self.loader.startAnimating()
            
            UserController.searchUsers(byUsername: name) { (users) in
                self.usersList = users
                self.usersCollection.reloadData()
                
                self.loader.stopAnimating()
                self.loader.isHidden = true
            }
        }
        else
        {
            //TODO: show alert no users
        }
    }

    //MARK: UITextFiled delegate
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        if let prefixName = textField.text
        {
            searchUsersBy(name: prefixName)
        }
        
        return true
    }
    
    //MARK: Collection view delegate, data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return usersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        
        cell.user = usersList[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.frame.width
        let height = width * 0.2
        
        return CGSize(width: width, height: height)
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
        return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}
