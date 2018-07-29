//
//  UserHistoryViewController.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/8/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
import Firebase
// show the list of picks for a given user
class UserHistoryViewController: UIViewController {
    var ref = Database.database().reference()
    var refHandle: DatabaseHandle?
    var user: User?
    var matchupList: [Matchup] = []
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // load matchups and put into matchupList
    // the specific data about that matchup is fetched in HistoryCell
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = user?.name ?? "no Name"
        tableView.dataSource = self
        // fetch user matchups
        refHandle = self.ref.child("users").child((user?.id)!).child("Matchups").observe(DataEventType.value){
            (snapshot) in
            let matchups = snapshot.value as? [String: [String: Any]] ?? [:]
            for(key, value) in matchups {
                // make fake matchup- only need to change the matchup name
                let date = "12-12-12" // fake date not needed
                let team1 = Team(Conference: "fake", Logo: "fake", Losses: 0, Name: "Fake", Wins: 0)
                let team2 = Team(Conference: "fake", Logo: "fake", Losses: 0, Name: value["Team"] as! String, Wins: 0)
                var matchup = Matchup(t1: team1, t2: team2, dt: date)
                
                matchup.name = key
                self.matchupList.append(matchup)
            }
            self.user?.matchups = self.matchupList
            
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension UserHistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let matchups = user?.matchups{
            return (user?.matchups.count)!
        }
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        cell.configure(mtchp: (user?.matchups[indexPath.item])!, usr: user)
        return cell
    }
    
}
