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
        super.viewDidLoad()
        tableView.dataSource = self
        self.ref.child("users").observe(DataEventType.value){
            (snapshot) in
            let userList = snapshot.value as? [String: [String:Any]] ?? [:]
            for (key, value) in userList{
                let newUser = User(nm: value["Name"] as? String ?? "NoName", pts: value["Points"] as? Int ?? -10000, nc: value["NumCorrect"] as? Int ?? -10)
                newUser.id = key
                newUser.calculateCurrentPoints()
                self.UserList.append(newUser)
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
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
        for i in 0..<UserList.count{
            for j in 0..<UserList.count-1{
                if(UserList[j].numCorrect < UserList[j+1].numCorrect){
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
        for i in 0..<UserList.count{
            for j in 0..<UserList.count-1{
                if(UserList[j].points < UserList[j+1].points){
                    let first = UserList[j]
                    let second = UserList[j+1]
                    UserList[j] = second
                    UserList[j+1] = first
                }
            }
        }
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
        cell.configure(nm: UserList[indexPath.item].name!, pts: UserList[indexPath.item].points, nc: UserList[indexPath.item].numCorrect)
        return cell
    }
    
}

