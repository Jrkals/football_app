//
//  Music.swift
//  FootballPickEmApp
//
//  Created by Justin on 12/11/17.
//  Copyright © 2017 Justin Kalan. All rights reserved.
//

import AVFoundation
import UIKit
// global music player class to sync music from different view controllers
class Music {
    
    static var shared = Music()
    
    var musicPlayer = AVAudioPlayer()
    
}
