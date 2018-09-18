//
//  UserStandingCell.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/3/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit

class UserStandingCell: UITableViewCell {
    
    var name: String = ""
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(user: User?){
        let nm = user?.name ?? "No Name"
        print(name)
        nameLabel.text = stripEndOfEmail(name: nm)
    }
    // cut everything past @ sign
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
