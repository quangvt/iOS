//
//  ViewController.swift
//  RPS
//
//  Created by Quang Vu on 4/10/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let winSound = SimpleSound(named: "win")
    let loseSound = SimpleSound(named: "lose")
    let drawSound = SimpleSound(named: "draw")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UpdateUI(GameState.start)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var appSignLabel: UILabel!
    
    @IBOutlet weak var statusOfGame: UILabel!

    @IBOutlet weak var buttonRock: UIButton!
    
    @IBOutlet weak var buttonPaper: UIButton!

    @IBOutlet weak var buttonScissors: UIButton!
    
    @IBOutlet weak var playAgain: UIButton!

    @IBAction func playRock(_ sender: Any) {
        play(.rock)
    }

    @IBAction func playPaper(_ sender: Any) {
        play(.paper)
    }
    
    @IBAction func playScissors(_ sender: Any) {
        play(.scissors)
    }

    @IBAction func actPlayAgain(_ sender: Any) {
        UpdateUI(GameState.start)
    }
    
    func UpdateUI(_ gameState: GameState) {
        statusOfGame.text = "Status: \(gameState)"
        setBGColorByState(gameState)
        switch gameState {
            case .start:
                appSignLabel.text = "🤖"
                playAgain.isHidden = true
                buttonRock.isHidden = false
                buttonRock.isEnabled = true
                buttonPaper.isHidden = false
                buttonPaper.isEnabled = true
                buttonScissors.isHidden = false
                buttonScissors.isEnabled = true
                print("Start: \(gameState)")
            default:
                print("Do nothing: \(gameState)")
        }
        
    }
    
    func setBGColorByState(_ gameState: GameState) {
        var color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        switch gameState {
            case .start:
                color = UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1)
                //color = UIColor.green
            case .draw:
                drawSound.play()
                color = UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
                //color = UIColor.magenta
            case .lose:
                loseSound.play()
                color = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
                //color = UIColor.gray
            case .win:
                winSound.play()
                color = UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1)
                //color = UIColor.red
        }
        view.backgroundColor = color
    }
    
    func play(_ sign: Sign){
        // get random sign for app
        let appSign = randomSign()
        
        // get state of play: user vs app
        let state = sign.play(appSign)
        
        // update UI by state
        UpdateUI(state)
        
        // update App Sign Label by app's sign
        switch appSign {
            case .paper:
                appSignLabel.text = "✋"
            case .rock:
                appSignLabel.text = "✊"
            case .scissors:
                appSignLabel.text = "✌️"
        }
        
        // disable all of the player sign button
        buttonRock.isEnabled = false
        buttonPaper.isEnabled = false
        buttonScissors.isEnabled = false
        
        // hide button
        buttonRock.isHidden = (sign != .rock)
        buttonPaper.isHidden = (sign != .paper)
        buttonScissors.isHidden = (sign != .scissors)
        
        // show play again button
        playAgain.isHidden = false
    }
}

