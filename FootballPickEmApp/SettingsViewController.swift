//
//  SettingsViewController.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/9/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // sign out
    @IBAction func signOutButtonTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "toSignIn", sender: self)
    }
    
    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toChangePassword", sender: self)
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toDeleteAccount", sender: self)
    }
    
}

