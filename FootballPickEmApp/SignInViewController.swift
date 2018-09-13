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
    /* Actions for text fields
    */
    
    @IBAction func doneEditingUsername(_ sender: Any) {
        usernameField.resignFirstResponder()
    }
    
    @IBAction func doneEditingPassword(_ sender: Any) {
        passwordField.resignFirstResponder()
    }
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var recognizer: UITapGestureRecognizer?
    
    // fills out default values and lets user tap to dismiss keyboard
    override func viewDidLoad() {
        print(Week.sharedWeek.wkString) // building it now so that by the next VC it has a value
        print(Week.previousWeek.wkString) // ''
        usernameField.text = UserDefaults.standard.string(forKey: "username")
        passwordField.text = UserDefaults.standard.string(forKey: "password")
        recognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.handleTap))
        view.addGestureRecognizer(recognizer!)
    }
    
    @objc func handleTap(){
        passwordField.resignFirstResponder()
        usernameField.resignFirstResponder()
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
                print(user?.email ?? "No email")
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
    // For those without an account
    //Required to fit Apple privacy requirements
    @IBAction func signInWithoutAccountTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: "genericemail@email.com", password: "genericPassword"){
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
                print(user?.email ?? "no email")
                
                self.performSegue(withIdentifier: "ToNext", sender: self)
            }
        }
    }
}
