//
//  PlayerDescriptors.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//


import RedCat

// MARK: Human

struct HumanPlayer : PlayerDescriptor, Equatable {
    
    var title : String {
        "Human"
    }
    
    var description : String {
        "This is you!"
    }
    
    var rawPlayer: RawPlayer {
        .human
    }
    
}

// MARK: RandomAI

struct RandomAI : PlayerDescriptor, Equatable {
    
    var delayMs : Int
    
    init(delayMs: Int = 200) {
        self.delayMs = delayMs
    }
    
    var title : String {
        "Random AI"
    }
    
    var description : String {
        "An AI that makes random moves with a delay of \(delayMs) milliseconds."
    }
    
    var rawPlayer: RawPlayer {
        .randomAI
    }
    
}
