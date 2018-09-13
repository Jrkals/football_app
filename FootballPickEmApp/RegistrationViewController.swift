//
//  RegistrationViewController.swift
//  FootballPickEmApp
//
//  Created by Justin on 11/28/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    var newUserDict: [String: Any] = ["Matchups": [[:]], "Points": [], "NumCorrect": [], "TotalPoints": 0, "TotalCorrect": 0]
    let ref = Database.database().reference()

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    var recognizer: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationViewController.handleTap))
        view.addGestureRecognizer(recognizer!)
    }
    
    @objc func handleTap(){
        confirmPasswordField.resignFirstResponder()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        if(passwordField.text != confirmPasswordField.text!) {
            warningLabel.isHidden = false
        }
        else { // passwords match
            Auth.auth().createUser(withEmail: usernameField.text!, password: passwordField.text!) {
                (user, error) in
                if let error = error {
                    print(error)
                }
                // got a proper user
                else if user != nil {
                    self.ref.child("users").child((user?.uid)!).setValue(self.newUserDict)
                    self.ref.child("users").child((user?.uid)!).child("Name").setValue(user?.email) // set name
                    User.shared.id = user?.uid // set the global user id on the app for database purposes
                    User.shared.name = user?.email
                    print("success, created new user")
                    print (user?.email ?? "no email")
                    UserDefaults.standard.set(self.usernameField.text!, forKey: "username")
                    UserDefaults.standard.set(self.passwordField.text!, forKey: "password")
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "toMain", sender: self)
                }
            }
        }
    }
    
    
}
