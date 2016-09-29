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

    @IBOutlet weak var notificationSoundButton: NSPopUpButton!
    @IBOutlet weak var embedAlbumArtworkButton: NSPopUpButton!
    @IBOutlet weak var spotifyHasFocusButton: NSPopUpButton!
    @IBOutlet weak var launchOnLoginButton: NSPopUpButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        notificationSoundButton.selectItem(at: fetchPreference("playSoundOnNotification"))
        embedAlbumArtworkButton.selectItem(at: fetchPreference("embedAlbumArtwork"))
        spotifyHasFocusButton.selectItem(at: fetchPreference("disableWhenSpotifyHasFocus"))
        
        if Bundle.main.isLoginItemEnabled() {
            launchOnLoginButton.selectItem(at: 0)
        } else {
            launchOnLoginButton.selectItem(at: 1)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func PreferenceSet(_ sender: NSPopUpButton) {
        let identifier : String = sender.identifier!
        
        if identifier == "launchOnLogin" {
            if sender.indexOfSelectedItem == 0 {
                Bundle.main.enableLoginItem()
            } else {
                Bundle.main.disableLoginItem()
            }
        } else {
            setPreference(identifier, value: sender.indexOfSelectedItem)
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

