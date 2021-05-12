//
//  PlayerDescriptors.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//


import RedCat

// MARK: Human

struct HumanPlayer : PlayerDescriptor {
    
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

struct RandomAI : PlayerDescriptor {
    
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
    
    static let reducer = AIReducer()
    
    struct AIReducer : ReducerWrapper {
        let body = delayReducer
    }
    
    static let delayReducer = Reducer {
        (action: Actions.ChangeDelay, state: inout RandomAI) in
        state.delayMs = action.newValue
    }
    
}
