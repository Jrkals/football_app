//
//  SettingsViewController.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/9/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class SettingsViewController: UIViewController {
    // song options
    var pickerOptions: [String] = []//  ["bcs_theme_audio", "cbsSports", "shipping up to boston", "drumABC", "playoff", "oldABCsports"]
        
    @IBOutlet weak var musicPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicPicker.delegate = self
        musicPicker.dataSource = self
    }
    // sign out
    @IBAction func signOutButtonTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "toSignIn", sender: self)
    }
    
    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toChangePassword", sender: self)
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toDeleteAccount", sender: self)
    }
    
    //play music
    func playSong(songName:String){
        
        let song = Bundle.main.path(forResource: songName, ofType: ".mp3")
        Music.shared.musicPlayer.stop()
        do{
            if let song = song{
                try Music.shared.musicPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: song))
                Music.shared.musicPlayer.play()
            }
        }
        catch {
            print(error)
        }
    }
    
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        playSong(songName: pickerOptions[row])
        print(pickerOptions[row])
    }
}

extension SettingsViewController: UIPickerViewDataSource {
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
