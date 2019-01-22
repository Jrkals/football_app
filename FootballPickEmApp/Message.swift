//
//  Message.swift
//  FootballPickEmApp
//
//  Created by Justin on 10/14/18.
//  Copyright © 2018 Justin Kalan. All rights reserved.
//

import Foundation
import Firebase

class Message{
    var ref = Database.database().reference()
    static var sharedMessage = Message()
    var messageString: String?
    init(){
        ref.child("Message").observeSingleEvent(of: .value, with: { (snapshot) in
            self.messageString = snapshot.value as? String ?? ""
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
}
