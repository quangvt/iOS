//
//  ViewController.swift
//  ShakeAndSwipe
//
//  Created by Quang Vu on 5/27/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var player: AVAudioPlayer = AVAudioPlayer()
    
    var sounds = ["01", "02", "03", "04 RippingExplosion", "05 Flute Sneak Up Accent", "06 Harp Snap", "07 Screeching Sinister Laugh", "08 Single Gun Shot with Ricochet", "09 Sinister Laugh from Male", "10 Violin Sneak Up Accent with Slides"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake {
            var randomNumber = Int(arc4random_uniform(UInt32(sounds.count)))
            var fileLocation = Bundle.main.path(forResource: sounds[randomNumber], ofType: "mp3")
            var error: NSError? = nil
            try? player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileLocation!))
            player.play()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

