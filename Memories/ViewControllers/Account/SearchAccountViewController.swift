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
    
    var albumToShare: PhotoAlbum?
    
    private var selectedUser: User?
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
    

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "FriendsAccountOverviewSegue"
         {
            if let accountVC = segue.destination as? FriendAccountOverviewViewController
            {
                accountVC.userAccount = self.selectedUser
            }
        }
    }
    
    func searchUsersBy(name: String)
    {
        if name != ""
        {
            self.loader.isHidden = false
            self.loader.startAnimating()
            
            UserController.searchUsers(byUsername: name) { (users) in
                self.usersList.removeAll()
                self.usersCollection.reloadData()
                
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
    
    func showAddUserAlert()
    {
        let alert = UIAlertController(title: "Add user", message: "Are you sure you want to add \(selectedUser?.username ?? "") on album \(albumToShare?.name ?? "")?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:{ (action) in
            
            UserController.addUserOnAlbum(user: self.selectedUser!, album: self.albumToShare!)
            UserController.addFriend(userId: self.selectedUser!.ID, forUser: MyAccount.sharedInstance.myUser!.ID)
            
            let notification = RemoteNotification(withId: "", title: "New shared album", body: "\(MyAccount.sharedInstance.myUser!.username) added you on new album \(self.albumToShare!.name)", date: Date().getString(), action: ActionType.showSharedAlbums.rawValue, objectId: self.albumToShare!.ID, read: false)
            RemoteNotificationController.addNotification(notification: notification, forUser: self.selectedUser!)
            
            let confirmAlert = UIAlertController(title: "User added", message: "User \(self.selectedUser?.username ?? "") is added on album.", preferredStyle: UIAlertControllerStyle.alert)
            confirmAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
            self.present(confirmAlert, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: UITextFiled delegate
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var currentString = ""
        if range.length == 0 {
            if let tfs = textField.text {
                currentString = tfs
            }
            currentString.append(string)
        } else {
            currentString = textField.text!
            currentString.removeLast()
        }
        
        print(currentString)
        searchUsersBy(name: currentString)
        
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
        
        let userView = UserViewModel(user: usersList[indexPath.item])
        userView.configure(cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.selectedUser = usersList[indexPath.row]
        if self.albumToShare != nil {
            self.showAddUserAlert()
        } else {
            self.performSegue(withIdentifier: "FriendsAccountOverviewSegue", sender: self)
        }
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
