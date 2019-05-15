//
//  NotificationsViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/11/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var notifications = [RemoteNotification]()
    @IBOutlet weak var notificationsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationsCollection.delegate = self
        notificationsCollection.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        RemoteNotificationController.getNotifications(forUserId: MyAccount.sharedInstance.userId ?? "") { (remoteNotifications) in
            self.notifications = remoteNotifications
            self.notificationsCollection.reloadData()
        }
    }

    //MARK: CollectionView delegate, data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationCell", for: indexPath) as? NotificationCell
        
        cell?.notificationData = self.notifications[indexPath.row]
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let notification = self.notifications[indexPath.row]
        
        if !notification.readStatus
        {
            notification.readStatus = true
            self.notificationsCollection.reloadData()
            
            RemoteNotificationController.markAsReadNotification(notification, forUserID: MyAccount.sharedInstance.myUser!.ID)
        }
        
        if notification.actionType == ActionType.showSharedAlbums
        {
            InternalNavigationController.sharedInstance.navigateToSharedAlbums()
        }
        else if notification.actionType == ActionType.showMyAlbums
        {
            InternalNavigationController.sharedInstance.navigateToMyAlbums()
        }
        else if notification.actionType == ActionType.showAlbum
        {
            if let albumId = notification.objectActionId {
                PhotoAlbumController.isSharedAlbum(albumID: albumId, forUser: MyAccount.sharedInstance.myUser!) { (contains) in
                    if contains {
                        InternalNavigationController.sharedInstance.navigateToSharedAlbums()
                    } else {
                        InternalNavigationController.sharedInstance.navigateToMyAlbums()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.frame.width
        let height = width * 200 / 1242
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        let insset:CGFloat = 0.0
        return insset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        let insset:CGFloat = 0.0
        return insset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let insset:CGFloat = 0.0
        return UIEdgeInsets.init(top: insset, left: insset, bottom: 0.0, right: insset)
    }
}
