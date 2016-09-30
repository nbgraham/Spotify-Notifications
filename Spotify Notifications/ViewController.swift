//
//  ViewController.swift
//  Spotify Notifications
//
//  Created by Mihir Singh on 1/7/15.
//  Copyright (c) 2015 citruspi. All rights reserved.
//

import Cocoa
import NSBundle_LoginItem

class ViewController: NSViewController {
    
    /*
     Button              Preferency Key              Purpose
     -----------------------------------------------------------------------------------------
     notificationSound   playSoundOnNotification     Play a sound before each notification.
     embedAlbumArtwork   embedAlbumArtwork           Embed the album artwork in notifications.
     spotifyHasFocus     disableWhenSpotifyHasFocus  Disable notifications when the Spotify
     has focus
     launchOnLogin       n/a                         Automatically launch the application on
     login
     
     */
    
    @IBOutlet weak var notificationSoundCheckBox: NSButton!
    @IBOutlet weak var embedAlbumArtworkCheckBox: NSButton!
    @IBOutlet weak var hideSpotifyHasFocusCheckBox: NSButton!
    @IBOutlet weak var launchOnLoginCheckBox: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if notificationSoundCheckBox.state == 0 {
            notificationSoundCheckBox.setNextState()
        }
        
        if embedAlbumArtworkCheckBox.state == 0 {
            embedAlbumArtworkCheckBox.setNextState()
        }
        
        if hideSpotifyHasFocusCheckBox.state == 0 {
            hideSpotifyHasFocusCheckBox.setNextState()
        }
        
        let defaultState = Bundle.main.isLoginItemEnabled() ? 1 : 0
        if launchOnLoginCheckBox.state != defaultState {
            launchOnLoginCheckBox.setNextState()
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func PreferenceSet(_ sender: NSButton) {
        let identifier : String = sender.identifier!
        
        if identifier == "launchOnLogin" {
            if sender.state == 0 {
                Bundle.main.enableLoginItem()
            } else {
                Bundle.main.disableLoginItem()
            }
        } else {
            setPreference(identifier, value: sender.state)
        }
    }
    
    func setPreference(_ key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func fetchPreference(_ key: String, fallback: Int = 0) -> Int {
        if let preference: AnyObject = UserDefaults.standard.object(forKey: key) as AnyObject? {
            return preference as! Int
        } else {
            return fallback
        }
    }
    
}

