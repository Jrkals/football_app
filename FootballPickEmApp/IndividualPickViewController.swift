//
//  IndividualPickViewController.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/4/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
import Firebase
// VC for individual matchup, displays teams and lets user pick team with some point value
class IndividualPickViewController: UIViewController {
    let ref = Database.database().reference()
    var refHandle: DatabaseHandle?
    
    var matchup: Matchup?
    var pickerOptions: [String] = ["Make A Pick"] // choices for picker-will be team names
    var teamPicked: String = ""
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var team1Image: UIImageView!
    
    @IBOutlet weak var team2Image: UIImageView!
    
    @IBOutlet weak var team1ConferenceLabel: UILabel!
    
    @IBOutlet weak var team2ConferenceLabel: UILabel!
    
    @IBOutlet weak var team1RecordLabel: UILabel!
    
    @IBOutlet weak var team2RecordLabel: UILabel!
    
    @IBOutlet weak var confidencePointsField: UITextField!
    
    @IBOutlet weak var team1RankLabel: UILabel!
    
    @IBOutlet weak var team2RankLabel: UILabel!
    
    var recognizer: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confidencePointsField.keyboardType = UIKeyboardType.numberPad
        
        recognizer = UITapGestureRecognizer(target: self, action: #selector(IndividualPickViewController.handleTap))
        view.addGestureRecognizer(recognizer!)
        picker.dataSource = self
        picker.delegate = self
        // show record
        guard let t1Wins = matchup?.team1?.wins else {return}
        guard let t2Wins = matchup?.team2?.wins else {return}
        guard let t1Losses = matchup?.team1?.losses else {return}
        guard let t2Losses = matchup?.team2?.losses else {return}
        team1RecordLabel.text = String(describing: t1Wins) + " - " + String(describing: t1Losses)
        team2RecordLabel.text = String(describing: t2Wins) + " - " + String(describing: t2Losses)
        
        team1ConferenceLabel.text = matchup?.team1?.conference
        team2ConferenceLabel.text = matchup?.team2?.conference
        
        let team1RankLabelPoundSign: String = "#"
        let team2RankLabelPoundSign: String = "#"
        
        team1RankLabel.text = team1RankLabelPoundSign + matchup!.team1!.ranking
        team2RankLabel.text = team2RankLabelPoundSign + matchup!.team2!.ranking
        dateLabel.text = matchup?.date
        
        // fetch two team logos
        ImageService.shared.fetchImage(url: (matchup?.team1?.logo)!) {
            (image) in
            DispatchQueue.main.async {
                self.team1Image.image = image
            }
            
        }
        ImageService.shared.fetchImage(url: (matchup?.team2?.logo)!) {
            (image) in
            DispatchQueue.main.async {
                self.team2Image.image = image
            }
            
        }
        pickerOptions.append((matchup?.team1?.name)!)
        pickerOptions.append((matchup?.team2?.name)!)
            
        }
    // dismiss points keyboard
    @objc func handleTap(){
        confidencePointsField.resignFirstResponder()
    }
    // upload pick to database
    func makePick(teamName: String){
        self.ref.child("users").child(User.shared.id!).child("Matchups").child(Week.sharedWeek.wkString).child((matchup?.name)!).child("Team").setValue(teamName)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //make pick if valid, then go back
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        guard let cpNum = Int(confidencePointsField.text!) else {return}
        if(cpNum < 11 && cpNum > 0){
            self.ref.child("users").child(User.shared.id!).child("Matchups").child(Week.sharedWeek.wkString).child((matchup?.name)!).child("Points").setValue(Int(confidencePointsField.text!))
            makePick(teamName: teamPicked)
            dismiss(animated: true, completion: nil)
        }
        else{
            warningLabel.isHidden = false
        }
    }
    
}

extension IndividualPickViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // makePick(teamName: pickerOptions[row])
        teamPicked = pickerOptions[row]
        print(pickerOptions[row])
    }
}

extension IndividualPickViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
}
