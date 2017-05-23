//
//  AudioPlayerView.swift
//  mp3zing
//
//  Created by Quang Vu on 5/19/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerView: UIViewController
{
    let audioPlayer = AudioPlayer.sharedInstance
    @IBOutlet weak var lbl_CurrentTime: UILabel!
    @IBOutlet weak var sld_Duration: UISlider!
    @IBOutlet weak var lbl_TotalTime: UILabel!
    @IBOutlet weak var btn_Play: UIButton!
    @IBOutlet weak var sld_Volume: UISlider!
//    @IBOutlet weak var lbl_Title: UILabel!
    var checkAddObserverAudio = false
    
    @IBOutlet weak var swt_Repeat: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btn_Play.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(setupObserveAudio), name: Notification.Name(rawValue: "setupObserveAudio"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupObserveAudio()
    }
    
    func changeInfoView()
    {
        changeInfoSong()
        addThumbImgForButton()
    }
    
    func changeInfoSong()
    {
//        lbl_Title.text = audioPlayer.titleSong
    }
    
    func addThumbImgForButton()
    {
        if (audioPlayer.playing == true) {
            btn_Play.setImage(UIImage(named: "pause.png"), for: .normal)
        } else {
            btn_Play.setImage(UIImage(named: "play.png"), for: .normal)
        }
    }
    
    func setupObserveAudio()
    {
        if (audioPlayer.playing && !checkAddObserverAudio) // Only add 1 timer
        {
            checkAddObserverAudio = true
            btn_Play.isEnabled = true
            _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   //object: audioPlayer.player.currentItem)
            object: nil)
        }
        
        changeInfoView()
    }
    
    func playerItemDidReachEnd(_ notification: Notification)
    {
//        notification.userInfo
        if (audioPlayer.repeating)
        {
            audioPlayer.player.seek(to: kCMTimeZero)
            audioPlayer.player.play()
        }
    }
    
    func timeUpdate() {
        audioPlayer.duration = Float((audioPlayer.player.currentItem?.duration.value)!)/Float((audioPlayer.player.currentItem?.duration.timescale)!)
        
        audioPlayer.currentTime = Float(audioPlayer.player.currentTime().value)/Float(audioPlayer.player.currentTime().timescale)
        
        let m = Int(floor(audioPlayer.currentTime/60))
        let s = Int(round(audioPlayer.currentTime - Float(m)*60))
        
        if (audioPlayer.duration > 0)
        {
            let mDuration = Int(floor(audioPlayer.currentTime/60))
            let sDuration = Int(round(audioPlayer.currentTime - Float(m)*60))
            self.lbl_CurrentTime.text = String(format: "%02d", m) +
                ":" + String(format: "%02d", s)
            self.lbl_TotalTime.text = String(format: "%02d", mDuration) +
                ":" + String(format: "%02d", sDuration)
            self.sld_Duration.value = Float(audioPlayer.currentTime/audioPlayer.duration)
            self.sld_Volume.value = audioPlayer.player.volume
            
        }
        
    }
    
    @IBAction func action_RepeatSong(sender: UISwitch) {
        audioPlayer.actionRepeatSong(sender.isOn)
    }
    
    @IBAction func action_PlayPause(sender: AnyObject) {
        audioPlayer.actionPlayPause()
        addThumbImgForButton()
    }
    @IBAction func action_SldDuration(sender: UISlider)
    {
        audioPlayer.actionSldDuration(value: sender.value)
    }
    @IBAction func action_SldVolume(sender: UISlider)
    {
        audioPlayer.actionSldVolume(value: sender.value)
    }
}
