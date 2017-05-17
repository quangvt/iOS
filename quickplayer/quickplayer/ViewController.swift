//
//  ViewController.swift
//  quickplayer
//
//  Created by Quang Vu on 5/15/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var sldVolume: UISlider!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var sldDuration: UISlider!
    @IBOutlet weak var swtRepeating: UISwitch!
    
    var player: AVAudioPlayer?
    var isPlaying = false
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize audio object
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "music", ofType: ".mp3")!)
        
        //player = try! AVAudioPlayer(contentsOf: url) // Old
        
        do {
            try player = AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            
            // set value for duration slider: Total Time & Max Value
            lblTotalTime.text = getMinSecStringFromDuration((player?.duration)!)
            sldDuration.maximumValue = Float((player?.duration)!)
            
            // Change Thumb Image for Volume Slider
            addThumbImgForVolumeSlider()
        }
        catch let error as NSError {
            print("audioPlayer error \(error.localizedDescription)")
        }
    }
    
    // MARK: Actions
    @IBAction func onClickPlayButton(_ sender: UIButton) {
        if let player = player {
            if !isPlaying {
                player.play()
                btnPlay.setImage(UIImage(named: "pause.png"), for: UIControlState())
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateScreen), userInfo: nil, repeats: true)
                
            } else {
                player.pause()
                btnPlay.setImage(UIImage(named: "play.png"), for: UIControlState())
                if let timer = timer { timer.invalidate() }
            }
            isPlaying = !isPlaying
        }
    }

    @IBAction func onChangeVolumeSlider(_ sender: UISlider) {
        if let player = player {
            player.volume = sender.value
        }
    }
    
    @IBAction func onChangeDurationSlider(_ sender: UISlider) {
        if let player = player {
            player.currentTime = Double(sldDuration.value)
        }
    }
    
    // MARK: Audio Player Delegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.currentTime = 0
        lblCurrentTime.text = "00:00"
        sldDuration.value = 0.0
        if (swtRepeating.isOn) {
            player.play()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateScreen), userInfo: nil, repeats: true)
        } else {
            btnPlay.setImage(UIImage(named: "play.png"), for: UIControlState())
            isPlaying = !isPlaying
        }
    }
    
    // MARK: Private Functions
    
    // Get text format: 00:00 (mm:ss) from timeinterval
    func getMinSecStringFromDuration(_ timeInterval: TimeInterval) -> String {
        let min: Int = Int(timeInterval / 60)
        let sec: Int = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        var sSec = ""
        var sMin = ""
        if (sec < 10) { sSec = "0\(sec)" } else { sSec = "\(sec)" }
        if (min < 10) { sMin = "0\(min)" } else { sMin = "\(min)" }
        return sMin + ":" + sSec
    }
    
    // Change the thumb affect when it moves
    func addThumbImgForVolumeSlider(){
        sldVolume.setThumbImage(UIImage(named: "thumb.png"), for: .normal)
        sldVolume.setThumbImage(UIImage(named: "thumbHightLight.png"), for: .highlighted)
    }
    
    // Update Screen when the audio is playing
    func updateScreen() {
        if let player = player {
            lblCurrentTime.text = getMinSecStringFromDuration(player.currentTime)
            sldDuration.value = Float(player.currentTime)
        }
    }
}

