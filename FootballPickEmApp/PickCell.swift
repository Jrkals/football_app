//
//  PickCell.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/4/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit

// shows names of two teams
class PickCell: UITableViewCell {
    var matchup: Matchup?
    @IBOutlet weak var team2Label: UILabel!
    
    @IBOutlet weak var team1Label: UILabel!
    func configure(mtchp: Matchup){
        matchup = mtchp
        team1Label.text = matchup?.team1?.name
        team2Label.text = matchup?.team2?.name
    }
    
    
    
    
    
}
