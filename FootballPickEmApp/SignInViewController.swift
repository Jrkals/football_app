//
//  SignInViewController.swift
//  FootballPickEmApp
//
//  Created by Justin on 11/26/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var recognizer: UITapGestureRecognizer?
    
    // fills out default values and lets user tap to dismiss keyboard
    override func viewDidLoad() {
        usernameField.text = UserDefaults.standard.string(forKey: "username")
        passwordField.text = UserDefaults.standard.string(forKey: "password")
        recognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.handleTap))
        view.addGestureRecognizer(recognizer!)
    }
    
    @objc func handleTap(){
        passwordField.resignFirstResponder()
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!){
            (user, error) in
            if let error = error {
                self.errorLabel.isHidden = false
                print("Error \(error)")
                return
            }
            if user != nil { // have valid user
                self.errorLabel.isHidden = true
                User.shared.id = user?.uid // set global id on app for database purposes
                User.shared.name = user?.email
                print(user?.email)
                UserDefaults.standard.set(self.usernameField.text!, forKey: "username")
                UserDefaults.standard.set(self.passwordField.text!, forKey: "password")
                UserDefaults.standard.synchronize()
                
                self.performSegue(withIdentifier: "ToNext", sender: self)
            }
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toRegistration", sender: self)
    }
    
}
