//
//  HistoryCell.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/8/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
import Firebase
// shows an individual pick made for one game and the points put on it
class HistoryCell: UITableViewCell {
    @IBOutlet weak var pickLabel: UILabel!
    
    @IBOutlet weak var gameNameLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    var ref = Database.database().reference()
    var user: User?
    func configure(mtchp: Matchup, usr: User?, wk: String?){
        user = usr
       // print(user?.id)
        self.ref.child("users").child((user?.id)!).child("Matchups").child(wk!).child(mtchp.name).observe(DataEventType.value){
            (snapshot) in
            let value = snapshot.value as? [String: Any] ?? [:]
            self.pickLabel.text = value["Team"] as? String ?? "No Pick"
            //if no result set both to gray
            if(value["Result"] as? String ?? "" == ""){
                self.pickLabel.textColor = UIColor.gray
                self.gameNameLabel.textColor = UIColor.gray
                self.pointsLabel.textColor = UIColor.gray
            }
            // if picker winner set to green
            else if(value["Team"] as? String ?? "No Pick" == value["Result"] as? String ?? "No result"){
                self.pickLabel.textColor = UIColor.green
                self.gameNameLabel.textColor = UIColor.green
                self.pointsLabel.textColor = UIColor.green
            }
            // missed pick, set to red
            else {
                self.pickLabel.textColor = UIColor.red
                self.gameNameLabel.textColor = UIColor.red
                self.pointsLabel.textColor = UIColor.red
            }
            
            self.pointsLabel.text = String(describing: value["Points"] as? Int ?? 0)
        }
        let str = mtchp.name.prefix(10) // only show the first 10 characters
        gameNameLabel.text! = String(str)
    }
    
}
