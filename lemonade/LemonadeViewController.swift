//
//  ViewController.swift
//  lemonade
//
//  Created by Paige Plander on 1/9/17.
//  Copyright © 2017 Paige Plander. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class LemonadeViewController: UIViewController {
    
    let systemPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    var playButton: UIButton = {
        var playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        playButton.setTitle("play", for: .normal)
        playButton.titleLabel?.textColor = UIColor.white
        playButton.layer.shadowColor = UIColor.black.cgColor
        playButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        playButton.layer.shadowRadius = 5
        playButton.layer.shadowOpacity = 1
        return playButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.yellow
        setUpConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLibraryAccess()
    }
    
    /// set up for the app's UI
    func setUpConstraints() {
        // UI for Bey's Image View
        let lemonadeView = UIImageView(frame: view.frame)
        lemonadeView.image = UIImage(named: "lemons")
        lemonadeView.contentMode = UIViewContentMode.scaleAspectFill
        view.addSubview(lemonadeView)
        
        // UI for the play button
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action:#selector(self.playButtonWasPressed(sender:)), for: .touchUpInside)
        view.addSubview(playButton)
        playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        playButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        
    }
    
    /// ask the user for permission to access their Apple Music Library
    func getLibraryAccess() {
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized:
            addLemonadeToQueue()
        case .notDetermined:
            MPMediaLibrary.requestAuthorization() { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.addLemonadeToQueue()
                    }
                }
            }
        default:
            print("Error occurred in authorization.")
            break
        }
    }
    
    /// If the album is present in the Apple Library, adds it to the system player's queue
    func addLemonadeToQueue() {
        let query = MPMediaQuery.albums()
        
        // Replace me with any album name
        let lemonadeFilter = MPMediaPropertyPredicate(value: "Lemonade",
                                                      forProperty: MPMediaItemPropertyAlbumTitle,
                                                      comparisonType: MPMediaPredicateComparison.equalTo)
        query.addFilterPredicate(lemonadeFilter)
        guard let result = query.collections else {
            return
        }
        
        // Add the album we queried for to the system player's queue
        for album in result {
            print("Album title = \(String(describing: album.representativeItem?.albumTitle))")
            systemPlayer.setQueue(with: album)
        }
    }
    
    func playButtonWasPressed(sender: UIButton) {
        // Make sure you call play to your system player in the completion handler
        // If you don't your queue may not be ready (and random songs will start playing)
        systemPlayer.prepareToPlay(completionHandler: {_ in
            self.systemPlayer.play()
        })
    }

}

