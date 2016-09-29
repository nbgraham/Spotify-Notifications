//
//  AppDelegate.swift
//  Spotify Notifications
//
//  Created by Mihir Singh on 1/7/15.
//  Copyright (c) 2015 citruspi. All rights reserved.
//

import Cocoa
import Foundation
import Alamofire
import SwiftyJSON

struct Track {
    var title: String? = nil
    var artist: String? = nil
    var album: String? = nil
    var artwork: NSImage? = nil
    var id: String? = nil
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var track = Track()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(playbackStateChanged(_:)), name: NSNotification.Name(rawValue: "com.spotify.client.PlaybackStateChanged"), object: nil)
    }
    
    func playbackStateChanged(_ aNotification: Notification) {
        let information : [AnyHashable: Any] = (aNotification as NSNotification).userInfo!
        let playbackState : String = (information["Player State"] as! NSString) as String
        
        if playbackState == "Playing" {
            track.title = (information["Name"] as! NSString) as String
            track.artist = (information["Artist"] as! NSString) as String
            track.album = (information["Album"] as! NSString) as String
            track.id = (information["Track ID"] as! NSString) as String

            if fetchPreference("embedAlbumArtwork") == 0 {
                let apiUri = "https://embed.spotify.com/oembed/?url=" + track.id!
            
                Alamofire.request(apiUri, method: .get).responseJSON { response in
                    
                    if let json = response.result.value {
                        
                        var json = JSON(json)
                        
                        let artworkLocation = URL(string: json["thumbnail_url"].stringValue)!
                        
                        let artwork = NSImage(contentsOf: artworkLocation)
                        self.track.artwork = artwork
                        
                    } else {
                        NSLog("Error: \(response)")
                    }
                }
            }

            let frontmostApplication : NSRunningApplication? = NSWorkspace.shared().frontmostApplication

            if frontmostApplication != nil {
                if frontmostApplication?.bundleIdentifier == "com.spotify.client" {
                    if fetchPreference("disableWhenSpotifyHasFocus") == 1 {
                        presentNotification()
                    }
                } else {
                    presentNotification()
                }
            }
        }
    }

    func presentNotification() {
        let notification:NSUserNotification = NSUserNotification()
        
        notification.title = track.title
        notification.subtitle = track.album
        notification.informativeText = track.artist
        
        if track.artwork != nil {
            notification.contentImage = track.artwork
        }
        
        if (self.fetchPreference("playSoundOnNotification") == 0) {
            notification.soundName = NSUserNotificationDefaultSoundName
        }

        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func fetchPreference(_ key: String, fallback: Int = 0) -> Int {
        if let preference: AnyObject = UserDefaults.standard.object(forKey: key) as AnyObject? {
            return preference as! Int
        } else {
            return fallback
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}
