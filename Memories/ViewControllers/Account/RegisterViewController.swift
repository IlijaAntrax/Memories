//
//  RegisterViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/10/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: KeyboardViewController {

    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var rePasswordTxtField: UITextField!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        self.usernameTxtField.delegate = self
        self.emailTxtField.delegate = self
        self.passwordTxtField.delegate = self
        self.rePasswordTxtField.delegate = self
        self.usernameTxtField.font = Settings.sharedInstance.fontRegularSizeMedium()
        self.emailTxtField.font = Settings.sharedInstance.fontRegularSizeMedium()
        self.passwordTxtField.font = Settings.sharedInstance.fontRegularSizeMedium()
        self.rePasswordTxtField.font = Settings.sharedInstance.fontRegularSizeMedium()
        
        loader.isHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func register(_ sender: Any)
    {
        guard let username = self.usernameTxtField.text, let email = self.emailTxtField.text, let password = self.passwordTxtField.text, let rePassword = self.rePasswordTxtField.text else {
            //TODO: Show alert missing username, email or password
            return
        }

        if password != rePassword
        {
            //TODO: Show alert unmatching passwords
        }
        else
        {
            loader.isHidden = false
            loader.startAnimating()
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                let myUser = UserController.addMyAccount(user: User.init(withID: "", username: username, email: email, firstname: "", lastname: "", imgUrl: ""))
                MyAccount.sharedInstance.logIn(user: myUser)
                
                self.loader.stopAnimating()
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
