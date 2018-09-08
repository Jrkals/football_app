//
//  StandingCell.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/7/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
// cell in Standings VC
class StandingCell: UITableViewCell {
    var name: String? = ""
    var points: Int = 0
    var numCorrect: Int = 0
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var numCorrectLabel: UILabel!
    
    func configure(nm: String, pts: Int, nc: Int){
        var name = nm
        points = pts
        numCorrect = nc
        
        // complicated ass way to get a substring
        if(name.count > 10){
            let range = name.index(nm.endIndex, offsetBy: -5)..<name.endIndex
            name.removeSubrange(range)
        }
        
        emailLabel.text = name
        pointsLabel.text = String(describing: points)
        numCorrectLabel.text = String(describing: numCorrect)
    }
}
