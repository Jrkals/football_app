//
//  StandingsViewController.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/3/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
import Firebase

// shows each user's points and numCorrect, can be sorted by buttons

class StandingsViewController: UIViewController {
    var UserList: [User] = []
    @IBOutlet weak var tableView: UITableView!
    var ref = Database.database().reference()
    
    
    // load list of users, calculate their points
    override func viewDidLoad() {
        fetchThisWeeksResults()
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.ref.child("users").observe(DataEventType.value){
            (snapshot) in
            let userList = snapshot.value as? [String: [String:Any]] ?? [:]
           // print(userList)
            for (_, value) in userList{
                let newUser = User(nm: value["Name"] as? String ?? "NoName", pts: value["Points"] as? Int ?? -10000, nc: value["NumCorrect"] as? Int ?? 0)
                self.UserList.append(newUser)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // Calculate one's own points for this week having read your total up to this point
        User.shared.calculateCurrentPoints(weekStr: Week.previousWeek.wkString)
        User.shared.calculateTotalPoints()
        
       // self.tableView.reloadData()
        
        print(UserList)
    }
    
    @IBAction func sortPointsTapped(_ sender: Any) {
        sortUserListByPoints()
        tableView.reloadData()
    }
    
    @IBAction func sortCorrectTapped(_ sender: Any) {
        sortUserListByNumCorrect()
        tableView.reloadData()
    }
    
    // simple bubble sort of list by num correct
    func sortUserListByNumCorrect(){
        for _ in 0..<UserList.count{
            for j in 0..<UserList.count-1{
                if(UserList[j].totalCorrect < UserList[j+1].totalCorrect){
                    let first = UserList[j]
                    let second = UserList[j+1]
                    UserList[j] = second
                    UserList[j+1] = first
                }
            }
        }
    }
    
    // simple bubble sort of list by Points
    func sortUserListByPoints(){
        for _ in 0..<UserList.count{
            for j in 0..<UserList.count-1{
                if(UserList[j].totalPoints < UserList[j+1].totalPoints){
                    let first = UserList[j]
                    let second = UserList[j+1]
                    UserList[j] = second
                    UserList[j+1] = first
                }
            }
        }
    }
    //TODO fix name of matchup in DB
    //Fetch this weeks results from matchups and write the result to users...matchups
    func fetchThisWeeksResults() {
        var winner: String?
        var matchupName: String?
        self.ref.child("matchups").child(Week.previousWeek.wkString).observe(DataEventType.value){
        (snapshot) in
            let matchList = snapshot.value as? [String: [String:Any]] ?? [:]
            for (_, value) in matchList{
               // print("fetched \(matchList.count) matches")
                // fetch winner
                winner = value["Result"] as? String ?? "No winner"
            //    print(winner ?? "no winner found")
                let t1 = value["Team1"] as? [String: Any] ?? [:]
                let t2 = value["Team2"] as? [String: Any] ?? [:]
                let team1 = Team(dictionary: t1)
                let team2 = Team(dictionary: t2)
                let mname = team1.name! + team2.name!
                matchupName = mname
                // if game played and recorded (there is a winner)
                if winner != "No winner" {
                    self.writeResults(winner: winner, name: matchupName)
                  //  print("called writeResults")
                }
            }
        }
    } // end fetch results
    
    //write results for oneself
    func writeResults(winner: String?, name: String?) {
        if(winner == "No winner"){
            print("winner is no winner")
        }
        self.ref.child("users").child(User.shared.id!).child("Matchups").child(Week.previousWeek.wkString).child(name!).child("Result").setValue(winner)
    }
    
}

extension StandingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandingCell") as! StandingCell
        cell.configure(nm: UserList[indexPath.item].name!, pts: UserList[indexPath.item].totalPoints, nc: UserList[indexPath.item].totalCorrect)
        return cell
    }
    
}

extension StandingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let UserHistoryVC = storyboard.instantiateViewController(withIdentifier: "UserHistoryViewController") as! UserHistoryViewController
        UserHistoryVC.user = UserList[indexPath.item]
        if(UserHistoryVC.user != nil){
            print(UserHistoryVC.user?.name)
          //  UserHistoryVC.present(UserHistoryVC, animated: true, completion: nil)
        }
        present(UserHistoryVC, animated: true, completion: nil)
    }
}

