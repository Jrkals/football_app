//
//  GroupViewController.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/3/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
import Firebase

class GroupViewController: UIViewController {
    
    var ref = Database.database().reference()
    var UserList: [User] = [] // add self to list
    @IBAction func myPicksButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ToMyPicks", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? UserHistoryViewController else { return }
        guard let source = sender as? GroupViewController else { return }
        destination.user = User.shared
    }
    
    @IBOutlet weak var tableView: UITableView!
    // loads list of users and presents their names
    override func viewDidLoad() {
        UserList = []
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.ref.child("users").observe(DataEventType.value){
            (snapshot) in
            let userList = snapshot.value as? [String: [String:Any]] ?? [:]
            for(key, value) in userList{
                let newUser = User(nm: value["Name"] as? String ?? "NoName", pts: value["Points"] as? Int ?? -10000, nc: value["NumCorrect"] as? Int ?? -10)
                newUser.id = key
              //  print(newUser.id)
                self.UserList.append(newUser)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

extension GroupViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserStandingCell") as! UserStandingCell
        cell.configure(user: UserList[indexPath.item])
        return cell
    }
}

extension GroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let UserHistoryVC = storyboard.instantiateViewController(withIdentifier: "UserHistoryViewController") as! UserHistoryViewController
        UserHistoryVC.user = UserList[indexPath.item]
        present(UserHistoryVC, animated: true, completion: nil)
    }
}


