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
    var points: Int = 0
    var numCorrect: Int = 0
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var numCorrectLabel: UILabel!
    
    func configure(nm: String, pts: Int, nc: Int){
        points = pts
        numCorrect = nc
        emailLabel.text = stripEndOfEmail(name: nm)
        pointsLabel.text = String(describing: points)
        numCorrectLabel.text = String(describing: numCorrect)
    }
    
    func stripEndOfEmail(name: String) -> String{
        let parts = name.split(separator: "@")
        var rv = String(describing: parts.first)
      //  print(rv)
        //remove last two chars which ar ")
        rv.removeLast()
        rv.removeLast()
        //remove first 9 chars which are Optional("
        for _ in 0...9{
            rv.remove(at: rv.startIndex)
        }
        return rv
    }
}
