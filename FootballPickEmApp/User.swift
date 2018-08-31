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
    var points: [Int] = [] // one entry per week
    var numCorrect: [Int] = [] // one entry per week
    // week[0] is useless, start week[1] as blank
    //TODO initialize 15 weeks of blank arrays
    var matchups: [[Matchup]] = [[], [], [], [], [], [], [], [], [],
                                 [], [], [], [], [], [], [], [], []] // 2d array of matchups, one array per week
    
    var totalPoints: Int
    var totalCorrect: Int
    
    init(nm: String?, pts: Int, nc: Int) {
        name = nm
        points.append(0)
        numCorrect.append(0)
        totalPoints = 0
        totalCorrect = 0
    }
    
    // compare picks vs results and add or subtract points accordingly
    func calculateCurrentPoints(user: User?, weekStr: String){
        refHandle = ref.child("users").child((user?.id)!).child("Matchups").child(weekStr).observe(DataEventType.value){
            (snapshot) in
            // User's picks
            let value = snapshot.value as? [String: [String:Any]] ?? [:]
            for(_, value) in value {
                if value["Result"] as? String ?? "" == value["Team"] as? String ?? "No Team" {
                    self.totalPoints += value["Points"] as? Int ?? 0
                    self.totalCorrect += 1
                    print("numcorrect is \(self.totalCorrect)")
                }
                else {
                    let v2 = value["Result"] as? String ?? ""
                    if v2.count > 0{
                        self.totalPoints -= value["Points"] as? Int ?? 0
                    }
                }
            } // end for
        } // end ref handle
        print("Points and num correct:")
        print(totalPoints)
        print(totalCorrect)
    } // end calculate Current points

    
}
