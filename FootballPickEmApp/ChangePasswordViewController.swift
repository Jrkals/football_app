//
//  ChangePasswordViewController.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/9/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPassword: UITextField!
    
    @IBOutlet weak var confirmNewPasswordField: UITextField!
    
    @IBOutlet weak var newPasswordField: UITextField!
    
    @IBOutlet weak var invalidOldPasswordLabel: UILabel!
    
    @IBOutlet weak var passwordMatchLabel: UILabel!
    
    var recognizer: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognizer = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.handleTap))
        view.addGestureRecognizer(recognizer!)
    }
    
    @objc func handleTap(){
        confirmNewPasswordField.resignFirstResponder()
    }
    
    // try to change password
    @IBAction func submitButtonTapped(_ sender: Any) {
        if self.oldPassword.text! != UserDefaults.standard.value(forKey: "password") as! String {
            invalidOldPasswordLabel.isHidden = false
        }
        else { // valid old password
            if(self.newPasswordField.text! == self.confirmNewPasswordField.text!){
                Auth.auth().currentUser?.updatePassword(to: self.newPasswordField.text!) { (error) in
                    if let error = error{ // failed update
                        print("error updating pasword \(error)")
                    }
                    else{ // succesfful update
                        self.performSegue(withIdentifier: "toTabBarFromPassword", sender: self)
                    }
                }
            }
            else{ // passwords don't match
                self.passwordMatchLabel.isHidden = false
            }
        }
    }
    
}
