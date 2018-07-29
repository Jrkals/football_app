//
//  User.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/5/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import Foundation
import Firebase

class User {
    var ref = Database.database().reference()
    var refHandle: DatabaseHandle?
    var refHandle2: DatabaseHandle?
    
    static var shared = User(nm: "YOU", pts: 0, nc: 0)
    var id: String? = ""
    
    var name: String?
    var points: Int = 0
    var numCorrect: Int = 0
    var matchups: [Matchup] = []
    
    init(nm: String?, pts: Int, nc: Int) {
        name = nm
        points = pts
        numCorrect = nc
    }
    
    // compare picks vs results and add or subtract points accordingly
    func calculateCurrentPoints(){
        refHandle = ref.child("users").child((Auth.auth().currentUser?.uid)!).child("Matchups").observe(DataEventType.value){
            (snapshot) in
            // User's picks
            let value = snapshot.value as? [String: [String:Any]] ?? [:]
            for(key, value) in value {
                self.refHandle2 = self.ref.child("Matchups").observe(DataEventType.value){
                    (snapshot) in
                    // Acual Results
                    let matchups = snapshot.value as? [String: [String:Any]] ?? [:]
                    for(key2, value2) in matchups{
                        if value2["Winner"] as? String ?? "" == value["Team"] as? String ?? "No Team" {
                            self.points += value["Points"] as? Int ?? 0
                        }
                        else {
                            let v2 = value2["Winner"] as? String ?? ""
                            if v2.count > 0{
                                self.points -= value["Points"] as? Int ?? 0
                            }
                        }
                    }
                    
                }
            }
            
            
        }
        
    }
    
}
