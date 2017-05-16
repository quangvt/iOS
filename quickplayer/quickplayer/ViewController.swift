//
//  ViewController.swift
//  quickplayer
//
//  Created by Quang Vu on 5/15/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblTimeLeft: UILabel!
    @IBOutlet weak var slideDuration: UISlider!
    
    var audio = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audio = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "music", ofType: ".mp3")!))
//        audio.prepareToPlay()
//        addThumImgForSlider()
//        audio.currentTime = 61.0
        // bai tap:
        //    change slide time
        //    
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLeft), userInfo: nil, repeats: true)
    }
    
    func addThumImgForSlider(){
        sliderVolume.setThumbImage(UIImage(named: "thumb.png"), for: .normal)
        sliderVolume.setThumbImage(UIImage(named: "thumbHightLight.png"), for: .highlighted)
        
    }
    
    func updateTimeLeft() {
        self.lblTimeLeft.text = String(format: "%2.2f", audio.currentTime/60)
        self.slideDuration.value = Float(audio.currentTime/audio.duration)
    }


    @IBAction func onClickPlay(_ sender: UIButton) {
        audio.play()
    }


    @IBAction func onChangeSlider(_ sender: UISlider) {
        print(sender.value)
        audio.volume = sender.value
    }
}

