//
//  welcomePageViewController.swift
//  FootballPickEmApp
//
//  Created by Justin on 11/28/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
// shows upcoming matchups in table view
class WelcomePageViewController: UIViewController {
    var refHandle: DatabaseHandle?

    var matchups: [Matchup] = []
    
    var ref: DatabaseReference = Database.database().reference()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var currentWeekLabel: UILabel!
    @IBOutlet weak var databaseMessageLabel: UILabel!
    
    // load table view from Firebase and display matchups
    override func viewDidLoad() {
        super.viewDidLoad()
        matchups = [] // empty list to avoid repeats when re-loading
        imageView.image = #imageLiteral(resourceName: "footballImage.jpg")
        tableView.dataSource = self
        tableView.delegate = self
        currentWeekLabel.text = Week.sharedWeek.wkString
        databaseMessageLabel.text = Message.sharedMessage.messageString
        // load from Firebase
        
        refHandle = ref.child("matchups").child(Week.sharedWeek.wkString).observe(DataEventType.value){
            (snapshot) in
         //   print(snapshot)
            let matchupArray = snapshot.value as? [String: [String: Any]] ?? [:]
            for (_, value) in matchupArray {
                let t1 = value["Team1"] as? [String: Any] ?? [:]
                let t2 = value["Team2"] as? [String: Any] ?? [:]
                let team1 = Team(dictionary: t1)
                let team2 = Team(dictionary: t2)
                //TODO get rid of date
                let date = value["Date"] as? String ?? ""
                let matchup = Matchup(t1: team1, t2: team2, dt: date, wk: Week.sharedWeek.wk)
                self.matchups.append(matchup)
                User.shared.matchups[Week.sharedWeek.wk].append(matchup)
                self.sortMatchupsByDate() // earliest first
               // print(matchup.team1?.conference)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        self.tableView.reloadData()
    }
    // Display in chronological order, earliest matchups first
    func sortMatchupsByDate(){
        for _ in 0..<matchups.count {
            for j in 0..<matchups.count-1 {
                if matchups[j].dateValue > matchups[j+1].dateValue {
                    let first = matchups[j]
                    let second = matchups[j+1]
                    matchups[j] = second
                    matchups[j+1] = first
                }
            }
        }
    }
}

extension WelcomePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickCell") as! PickCell
        cell.configure(mtchp: matchups[indexPath.item])
        return cell
    }
}

// go to individual pick VC to make specific pick
extension WelcomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let individualPickVC = storyboard.instantiateViewController(withIdentifier: "IndividualPickViewController") as! IndividualPickViewController
        individualPickVC.matchup = matchups[indexPath.item]
        present(individualPickVC, animated: true, completion: nil)
        
    }
    
}
