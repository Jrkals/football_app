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
    var isAnonymous: Bool
    
    init(nm: String?, pts: Int, nc: Int) {
        name = nm
        points.append(0)
        numCorrect.append(0)
        //Read database to get totalPoints and totalCorrect up to this point
        totalPoints = pts
        totalCorrect = nc
        isAnonymous = false
    }
    
    // compare picks vs results and add or subtract points accordingly
    // FInds totals for each week this is not the global total
    func calculateCurrentPoints(weekStr: String){
        if isAnonymous{
            return
        }
        self.totalPoints = 0
        self.totalCorrect = 0
        refHandle = ref.child("users").child((self.id)!).child("Matchups").child(weekStr).observe(DataEventType.value){
            (snapshot) in
            let value = snapshot.value as? [String: [String:Any]] ?? [:]
            for(_, value) in value {
           //     print(value["Result"] ?? "No result found")
           //     print(value["Team"] ?? "No team found")
                if value["Result"] as? String ?? "" == value["Team"] as? String ?? "No Team" {
                    self.totalPoints += value["Points"] as? Int ?? 0
                    self.totalCorrect += 1
                //    print("numcorrect is \(self.totalCorrect)")
                //    print("total points is\(self.totalCorrect)")
                }
                else {
                    let v2 = value["Result"] as? String ?? ""
                    if v2.count > 0{
                        self.totalPoints -= value["Points"] as? Int ?? 0
                    }
                }
            } // end for
            
            //Write weekly point total results to DB
            self.ref.child("users").child((self.id!)).child("Weeks").child(Week.previousWeek.wkString).child("Points").setValue(self.totalPoints)
            self.ref.child("users").child((self.id!)).child("Weeks").child(Week.previousWeek.wkString).child("NumCorrect").setValue(self.totalCorrect)

        } // end ref handle
       /* print("Points and num correct:")
        print(totalPoints)
        print(totalCorrect)*/
    } // end calculate Current points
    
    func calculateTotalPoints(){
        if isAnonymous{
            return
        }
        var totalPoints: Int = 0
        var totalRight: Int = 0
        refHandle = ref.child("users").child((self.id)!).child("Weeks").observe(DataEventType.value){
            (snapshot) in
            let value = snapshot.value as? [String: [String:Any]] ?? [:]
            for(_, value) in value {
                //add to sum each time
                totalPoints += value["Points"] as? Int ?? 0
                totalRight += value["NumCorrect"] as? Int ?? 0
            } // end for
            //write results to DB
            self.ref.child("users").child((self.id!)).child("Points").setValue(totalPoints)
            self.ref.child("users").child((self.id!)).child("NumCorrect").setValue(totalRight)
            
        } // end ref handle
    }
    
}
