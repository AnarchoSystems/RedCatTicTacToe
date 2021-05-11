//
//  PossiblePlayers.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import RedCat
import CasePaths

// swiftlint:disable identifier_name

enum PossiblePlayers : Emptyable {
    
    case human(HumanPlayer)
    case randomAI(RandomAI)
    
    static var empty : PossiblePlayers = .human(HumanPlayer())
    
    var title : String {
        switch self {
        case .human(let human):
            return human.title
        case .randomAI(let ai):
            return ai.title
        }
    }
    
    var player : PlayerDescriptor {
        switch self {
        case .human(let human):
            return human
        case .randomAI(let ai):
            return ai
        }
    }
    
    var description : String {
        switch self {
        case .human(let human):
            return human.description
        case .randomAI(let ai):
            return ai.description
        }
    }
    
    static let reducer = randomAIReducer
    
    static let randomAIReducer = Reducer(/PossiblePlayers.randomAI) {
        RandomAI.reducer
    }
    
}
