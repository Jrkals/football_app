//
//  Matchup.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/4/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import Foundation

class Matchup {
    
    static var thisWeeksMatchups = Matchup(t1: nil, t2: nil, dt: nil)
    
    var team1: Team?
    var team2: Team?
    var date: String = ""
    var name: String = ""
    var dateValue: Int = 0
    
    
    init(t1: Team?, t2: Team?, dt: String?) {
        team1 = t1!
        team2 = t2!
        date = dt!
        name = (team1?.name)! + (team2?.name)!
        dateValue = calculateDateValue(date: date)
    }
    
    func calculateDateValue(date: String) -> Int{
        let splitDate = date.split(separator: "-")
        if(splitDate[0] == "1"){
            return 32 + Int(String(splitDate[1]))!
        }
        else{
            return Int(String(splitDate[1]))!
        }
    }
    
}
