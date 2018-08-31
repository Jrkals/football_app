//
//  Week.swift
//  FootballPickEmApp
//
//  Created by Justin on 8/5/18.
//  Copyright © 2018 Justin Kalan. All rights reserved.
//

import Foundation
import Firebase

class Week {
    var wk: Int
    var wkString: String
    var ref = Database.database().reference()
    static var sharedWeek = Week() // global object to hold current week
    
    
    //Read current week from DB. This is manually changed by me weekly
    init(){
        // initialize
        wkString = "week"
        wk = 0
        // read from DB
        ref.child("CurrentWeek").observeSingleEvent(of: .value, with: { (snapshot) in
            self.wk = snapshot.value as! Int
            self.wkString += String (self.wk)
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
}
