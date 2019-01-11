//
//  LoginViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/8/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var contentViewBottomConstr: NSLayoutConstraint!
    
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.usernameTxtField.delegate = self
        self.passwordTxtField.delegate = self
        self.usernameTxtField.font = Settings.sharedInstance.fontRegularSizeMedium()
        self.passwordTxtField.font = Settings.sharedInstance.fontRegularSizeMedium()
        
        loader.isHidden = true
        
        //Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loginUser()
    {
        guard let email = self.usernameTxtField.text, let password = self.passwordTxtField.text else {
            //Show alert missing email or password
            return
        }
        
        loader.isHidden = false
        loader.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error
            {
                //Show alert with error
                print(err)
            }
            else if let user = user
            {
                //Retrive user from database and set MyAccount
                UserController.getUser(forEmail: user.email ?? email, completionHandler: { (myUser) in
                    MyAccount.sharedInstance.logIn(user: myUser)
                    
                    self.loader.stopAnimating()
                    
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func login(_ sender: Any)
    {
        let hide = hideKeyboardIfNeeded()
        
        if hide
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + k_KEYBOARD_ANIM_DURATION, execute: {
                self.loginUser()
            })
        }
        else
        {
            self.loginUser()
        }
    }
    
    // MARK: Keyboard animations
    var isKeyboardShown = false
    
    @objc func keyboardWillShow()
    {
        isKeyboardShown = true
    }
    
    @objc func keyboardWillHide()
    {
        isKeyboardShown = false
    }
    
    func hideKeyboardIfNeeded() -> Bool
    {
        if isKeyboardShown
        {
            self.view.endEditing(true)
            
            self.animateView(constant: 0)
            
            return true
        }
        return false
    }
    
    func animateView(constant: CGFloat)
    {
        UIView.animate(withDuration: k_KEYBOARD_ANIM_DURATION)
        {
            self.contentViewBottomConstr.constant = constant
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        self.animateView(constant: -(UIScreen.main.bounds.size.height * 0.3))
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.animateView(constant: 0)
        textField.resignFirstResponder()
        
        return true
    }
}
