//
//  KeyboardViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/11/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var contentViewBottomConstr: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
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
        if (self.contentViewBottomConstr != nil)
        {
            UIView.animate(withDuration: k_KEYBOARD_ANIM_DURATION)
            {
                self.contentViewBottomConstr.constant = constant
                self.view.layoutIfNeeded()
            }
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
