//
//  DeleteAccountViewController.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/9/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
import Firebase

class DeleteAccountViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var errorLabel: UILabel!
    
    // deletes account
    @IBAction func yesButtonTapped(_ sender: Any) {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print("error in deletion of account \(error)")
                self.errorLabel.isHidden = false
            } else {
                self.performSegue(withIdentifier: "toSignInFromDelete", sender: self)
            }
        }
    }
    // returns user to previous page
    @IBAction func noButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
