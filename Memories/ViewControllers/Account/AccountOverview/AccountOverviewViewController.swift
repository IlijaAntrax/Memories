//
//  AccountViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/11/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountOverviewViewController: UIViewController {
    
    var userAccount: User?
    
    @IBOutlet weak var myProfileHeaderView: MyProfileHeaderView!
    
    @IBOutlet var firstnameLbl: UILabel!
    @IBOutlet var firstnameTxtField: UITextField!
    @IBOutlet var lastnameLbl: UILabel!
    @IBOutlet var lastnameTxtField: UITextField!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var emailTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstnameLbl.font = Settings.sharedInstance.fontRegularSizeMedium()
        firstnameLbl.textColor = Settings.sharedInstance.grayNormalColor()
        firstnameLbl.text = "Firstname:"
        lastnameLbl.font = Settings.sharedInstance.fontRegularSizeMedium()
        lastnameLbl.textColor = Settings.sharedInstance.grayNormalColor()
        lastnameLbl.text = "Lastname:"
        emailLbl.font = Settings.sharedInstance.fontRegularSizeMedium()
        emailLbl.textColor = Settings.sharedInstance.grayNormalColor()
        emailLbl.text = "Email:"
        
        firstnameTxtField.font = Settings.sharedInstance.fontBoldSizeMedium()
        firstnameTxtField.textColor = Settings.sharedInstance.grayNormalColor()
        lastnameTxtField.font = Settings.sharedInstance.fontBoldSizeMedium()
        lastnameTxtField.textColor = Settings.sharedInstance.grayNormalColor()
        emailTxtField.font = Settings.sharedInstance.fontBoldSizeMedium()
        emailTxtField.textColor = Settings.sharedInstance.grayNormalColor()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.setupUserInfo()
    }
    
    func setupUserInfo()
    {
        myProfileHeaderView.setup(withDelegate: self, andUser: self.userAccount)
        
        firstnameTxtField.text = self.userAccount?.firstname
        lastnameTxtField.text = self.userAccount?.lastname
        emailTxtField.text = self.userAccount?.email
    }

}
