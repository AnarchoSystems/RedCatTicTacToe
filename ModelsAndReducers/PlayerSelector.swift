//
//  PlayerSelector.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 06.05.21.
//

import RedCat
import CasePaths
import Foundation


struct SelectedPlayers : Equatable {
    
    // swiftlint:disable identifier_name
    var x : PossiblePlayers = .human(HumanPlayer())
    var o : PossiblePlayers = .randomAI(RandomAI())
    // swiftlint:enable identifier_name
    
    subscript(_ player: Player) -> PossiblePlayers {
        get {
        switch player {
        case .x:
            return x
        case .o:
            return o
        }
        }
        set {
            switch player {
            case .x:
                x = newValue
            case .o:
                o = newValue
            }
        }
    }
    
    static let reducer = SelectedPlayersReducer()
    
    struct SelectedPlayersReducer : ReducerProtocol {
        
        func apply(_ action: AppAction.GameConfig.ConfigAction,
                   to state: inout SelectedPlayers) {
            switch action {
            case .selectPlayer(player: let player, oldValue: _, newValue: let newValue):
                state[player] = newValue
            case .changeAIDelay(player: let player, oldValue: _, newValue: let newValue):
                (/PossiblePlayers.randomAI).mutate(&state[player]) {randomAI in
                    randomAI.delayMs = newValue
                }
            }
        }
        
    }
    
}


protocol ActionForPlayer {
    var player : Player {get}
}
