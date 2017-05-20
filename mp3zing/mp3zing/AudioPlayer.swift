//
//  AudioPlayer.swift
//  mp3zing
//
//  Created by Quang Vu on 5/18/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject {
    // bien kieu class
//    class var sharedInstance: AudioPlayer
//    {
//        struct Static
//        {
//            static var onceToken: once_t = 0
//            static var instance: AudioPlayer? = nil
//        }
//        dispatch_once(&Static.onceToken)
//        {
//            Static.instance = AudioPlayer()
//        }
//        return Static.instance
//    }
    
    static let sharedInstance: AudioPlayer = { AudioPlayer() }()
    
    var pathString = ""
    var repeating = false
    var playing = false
    var duration = Float()
    var currentTime = Float()
    var titleSong = ""
    var player = AVPlayer() // can play online (stream)
    
    func setupAudio()
    {
        var url: URL
        if let checkURL = URL(string: pathString)
        {
            url = checkURL
        } else
        {
            url = URL(fileURLWithPath: pathString)
        }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player.rate = 1.0
        player.volume = 0.5
        player.play()
        playing = true
        repeating = true
    }
    
    // Action
    func actionRepeatSong(_ repeatSong: Bool)
    {
        if (repeating == true) {
            repeating = true
        } else {
            repeating = false
        }
        
    }
    
    func actionPlayPause()
    {
        if (playing == false) {
            player.play()
            playing = true
        } else {
            player.pause()
            playing = false
        }
    }
    
    func actionSldDuration(value: Float)
    {
        let timeToSeek = value * duration
        let time = CMTimeMake(Int64(timeToSeek), 1) // AVTime
        player.seek(to: time)
    }
    
    func actionSldVolume(value: Float)
    {
        player.volume = value
    }
    
}
