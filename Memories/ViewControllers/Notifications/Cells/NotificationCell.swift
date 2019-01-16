//
//  NotificationCell.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class NotificationCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImgView:UIImageView!
    
    @IBOutlet weak var textLbl:UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        //TODO: setup
        textLbl.font = Settings.sharedInstance.fontRegularSizeMedium()
        textLbl.textColor = Settings.sharedInstance.grayNormalColor()
        textLbl.numberOfLines = 2
        textLbl.adjustsFontSizeToFitWidth = true
    }
    
    var notificationData: RemoteNotification?
    {
        didSet
        {
            if let notificationData = self.notificationData
            {
                //TODO: setup icon depends of notification action
                //TODO: set atributed string
                let time = abs(Int(notificationData.date.timeIntervalSinceNow / 60.0))
                let txt = "\(notificationData.messageBody). \(time) min"
                textLbl.text = txt
            }
        }
    }
}
