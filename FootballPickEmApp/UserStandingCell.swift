//
//  UserStandingCell.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/3/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit

class UserStandingCell: UITableViewCell {
    
    var name: String?
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(user: User?){
        name = user?.name
        nameLabel.text = name!
    }
    
    
}
