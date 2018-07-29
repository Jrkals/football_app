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
    
    // load table view from Firebase and display matchups
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = #imageLiteral(resourceName: "footballImage.jpg")
        tableView.dataSource = self
        tableView.delegate = self
        // load from Firebase
        refHandle = ref.child("Matchups").observe(DataEventType.value){
            (snapshot) in
            let matchupArray = snapshot.value as! [String: [String: Any]]
            for (key, value) in matchupArray {
                let t1 = value["Team1"] as? [String: Any] ?? [:]
                let t2 = value["Team2"] as? [String: Any] ?? [:]
                let team1 = Team(dictionary: t1)
                let team2 = Team(dictionary: t2)
                let date = value["Date"] as? String ?? ""
                let matchup = Matchup(t1: team1, t2: team2, dt: date)
                self.matchups.append(matchup)
                User.shared.matchups.append(matchup)
                self.sortMatchupsByDate() // earliest first
               // print(matchup.team1?.conference)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
        self.tableView.reloadData()
        
        //play music
        let bcsSong = Bundle.main.path(forResource: "bcs_theme_audio", ofType: ".mp3")
        do{
            if let bcsSong = bcsSong{
                try Music.shared.musicPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: bcsSong))
                Music.shared.musicPlayer.play()
            }
        }
        catch {
            print(error)
        }
    }
    // Display in chronological order, earliest matchups first
    func sortMatchupsByDate(){
        for i in 0..<matchups.count {
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
    
    @IBAction func stopMusicButtonTapped(_ sender: Any) {
        Music.shared.musicPlayer.stop()
    }
    
    @IBAction func playMusicButtonTapped(_ sender: Any) {
        Music.shared.musicPlayer.play()
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
