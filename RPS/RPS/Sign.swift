//
//  Sign.swift
//  RPS
//
//  Created by Quang Vu on 4/10/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import Foundation
import GameplayKit

let randomChoice = GKRandomDistribution(lowestValue: 0, highestValue: 2)

func randomSign() -> Sign {
    let sign = randomChoice.nextInt()
    if sign == 0 {
        return .rock
    } else if sign == 1 {
        return .paper
    } else {
        return .scissors
    }
}

enum Sign {
    case rock, scissors, paper
    
    func play(_ opponentSign: Sign) -> GameState {
        switch opponentSign
        {
            case .rock:
                if self == .rock {
                    return GameState.draw
                } else if self == .paper {
                    return GameState.win
                } else if self == .scissors {
                    return GameState.lose
                }
            case .paper:
                if self == .rock {
                    return GameState.lose
                } else if self == .paper {
                    return GameState.draw
                } else if self == .scissors {
                    return GameState.win
                }
            case .scissors:
                if self == .rock {
                    return GameState.win
                } else if self == .paper {
                    return GameState.lose
                } else if self == .scissors {
                    return GameState.draw
                }
        }
        return GameState.draw
    }
}
