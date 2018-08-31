//
//  Matchup.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/4/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import Foundation

class Matchup {
    //TODDO find out why this is here
    static var thisWeeksMatchups = Matchup(t1: nil, t2: nil, dt: nil, wk: Week.sharedWeek.wk)
    
    var team1: Team?
    var team2: Team?
    var date: String = ""
    var name: String = ""
    var dateValue: Int = 0
    var result: String = ""
    let week: Int
    
    
    init(t1: Team?, t2: Team?, dt: String?, wk: Int?) {
        team1 = t1 ?? Team(dictionary: [:]) // generic team
        team2 = t2 ?? Team(dictionary: [:]) // generic team
        date = dt!
        name = (team1?.name)! + (team2?.name)!
        result = ""
        week = wk!
        // TODO going to deprecate and remove date since each
        // matchup has a week
     //   dateValue = self.calculateDateValue(date: date)
      
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
