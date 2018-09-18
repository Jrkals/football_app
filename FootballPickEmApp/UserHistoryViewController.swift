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
    var user: User?
    var matchupList: [[Matchup]] = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    var weekString = Week.sharedWeek.wkString
    var weekInt = Week.sharedWeek.wk
    
    @IBOutlet weak var weekPicker: UIPickerView!
    
    var pickerOptions: [String] = ["week1", "week2", "week3", "week4", "week5", "week6",
                                   "week7", "week8", "week9", "week10", "week11", "week12",
                                   "week13", "week14", "week15", "bowls"]
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // load matchups and put into matchupList
    // the specific data about that matchup is fetched in HistoryCell
    override func viewDidLoad() {
       // print("In view did load weekString is \(weekString)")
        print("in UHVC userid is \(user?.id ?? "no id") week is \(weekString)")
        super.viewDidLoad()
    //    matchupList = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []] // reset to emtpy when reloading. Fixes problem with reduplicating games
        
        weekPicker.delegate = self
        weekPicker.dataSource = self
        tableView.dataSource = self
        nameLabel.text = stripEndOfEmail(name: user?.name ?? "no Name")
        // fetch user matchups
        ref.child("users").child(user?.id ?? "FakeID").child("Matchups").child(weekString).observe(DataEventType.value){
            (snapshot) in
            print(snapshot)
            let matchups = snapshot.value as? [String: [String:Any]] ?? [:]
            print("MATCHUPS****************************")
          //  print(matchups)
         //   print("num matchups is \(self.matchupList[self.weekInt].count)")
            for(key, _) in matchups {
                // make fake matchup- only need to change the matchup name
                let date = "12-12-12" // fake date not needed
                let team1 = Team(Conference: "fake", Logo: "fake", Losses: 0, Name: "Fake", Wins: 0, Ranking: 100)
                let team2 = Team(Conference: "fake", Logo: "fake", Losses: 0, Name: "Fake", Wins: 0, Ranking: 100)
                let matchup = Matchup(t1: team1, t2: team2, dt: date, wk: self.weekInt)
                
                matchup.name = key
                self.matchupList[self.weekInt].append(matchup)
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

extension UserHistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let matchups = user?.matchups[weekInt]{
         //   print("there are for week: \(weekInt) \(user?.matchups[weekInt].count) matchups")
            return (user?.matchups[weekInt].count)!
        }
        else{
            return 0
        }
    }
    //TODO fix if no matchups
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
      //  print("weekInt is \(weekInt)")
        cell.configure(mtchp: (user?.matchups[weekInt][indexPath.item])!, usr: user, wk: weekString)
        return cell
    }
    
}

//Picker stuff
extension UserHistoryViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weekString = pickerOptions[row] // update new week for DB
        print("weekString is now \(weekString)")
        weekInt = row + 1 // starts at 0 for week 1 hence +1
        print("weekInt is now \(weekInt)")
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
