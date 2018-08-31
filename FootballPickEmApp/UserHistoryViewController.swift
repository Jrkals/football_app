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
    var matchupList: [[Matchup]] = [[], []]
    var weekString = Week.sharedWeek.wkString
    var weekInt = Week.sharedWeek.wk
    
    @IBOutlet weak var weekPicker: UIPickerView!
    
    var pickerOptions: [String] = ["week1", "week2", "week3", "week4", "week5", "week6",
                                   "week7", "week8", "week9", "week10", "week11", "week12",
                                   "week13", "week14", "week15", "bowls"]
    var weekPicked: String = "week1"
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // load matchups and put into matchupList
    // the specific data about that matchup is fetched in HistoryCell
    override func viewDidLoad() {
        matchupList = [[], []] // reset to emtpy when reloading. Fixes problem with reduplicating games
        super.viewDidLoad()
        weekPicker.delegate = self
        weekPicker.dataSource = self
        nameLabel.text = user?.name ?? "no Name"
        tableView.dataSource = self
        // fetch user matchups
        ref.child("users").child((user?.id)!).child("Matchups").child(Week.sharedWeek.wkString).observe(DataEventType.value){
            (snapshot) in
            print(snapshot)
            let matchups = snapshot.value as? [String: [String:Any]] ?? [:]
            print("MATCHUPS****************************")
            print(matchups)
            for(key, value) in matchups {
              //  print("matchups found")
                // make fake matchup- only need to change the matchup name
                let date = "12-12-12" // fake date not needed
                let team1 = Team(Conference: "fake", Logo: "fake", Losses: 0, Name: "Fake", Wins: 0, Ranking: 100)
                let team2 = Team(Conference: "fake", Logo: "fake", Losses: 0, Name: "Fake", Wins: 0, Ranking: 100)
                let matchup = Matchup(t1: team1, t2: team2, dt: date, wk: self.weekInt)
                
                matchup.name = key
                self.matchupList[Week.sharedWeek.wk].append(matchup)
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
        if weekInt >= (user?.matchups.count)! {
            return 0
        }
        else if let matchups = user?.matchups[weekInt]{
            return (user?.matchups[weekInt].count)!
        }
        else{
            return 0
        }
    }
    //TODO fix if no matchups
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        cell.configure(mtchp: (user?.matchups[weekInt][indexPath.item])!, usr: user)
        return cell
    }
    
}

//Picker stuff
extension UserHistoryViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weekPicked = pickerOptions[row] // set the weekpicked variable for the class
        weekString = pickerOptions[row] // update new week for DB
        weekInt = row + 1 // starts at 0 for week 1 hence +1
        tableView.reloadData()
        viewDidLoad()
        print(pickerOptions[row])
    }
}

extension UserHistoryViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    // not sure if this is needed just added it from SettingsVC
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    
}
