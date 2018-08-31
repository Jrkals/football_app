//
//  Team.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/4/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import Foundation

class Team {
    
    var name: String?
    var wins: Int?
    var losses: Int?
    var conference: String?
    var logo: URL
    var ranking: String
    
    
    init(Conference: String, Logo: String, Losses: Int, Name: String, Wins: Int, Ranking: Int){
        name = Name
        wins = Wins
        losses = Losses
        conference = Conference
        logo = URL(string: Logo)!
        // set as NR for not ranked or convert int to to string
        if(Ranking > 50){
            ranking = "NR"
        }
        else{
            ranking = String(Ranking)
        }
    }
    
    convenience init(dictionary: [String: Any]) {
        self.init(Conference: dictionary["Conference"] as? String ?? "GenericConference",
                  Logo: dictionary["Logo"] as? String ?? "hhttps://cdn.vox-cdn.com/uploads/chorus_image/image/37174542/cfbrevenuemap.0.0.jpg",
                  Losses: dictionary["Losses"] as? Int ?? 0,
                  Name: dictionary["Name"] as? String ?? "Generic Name",
                  Wins: dictionary["Wins"]as? Int ?? 0,
                  Ranking: dictionary["Ranking"] as? Int ?? 100)  // 100 for non top 25
    }
    
}
