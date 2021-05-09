//
//  PlayerSelector.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 06.05.21.
//

import RedCat
import CasePaths
import Foundation


struct SelectedPlayers {
    
    var x : PossiblePlayers = .human(HumanPlayer())
    var o : PossiblePlayers = .randomAI(RandomAI(player: .o))
    
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
    
    static let reducer = selectPlayerReducer
        .compose(with: xReducer)
        .compose(with: oReducer)
    
    
    static let selectPlayerReducer = Reducer {
        Reducer {
            (action: Actions.SelectPlayer, state: inout SelectedPlayers) in
            state[action.player] = action.newValue
        }
    }
    
    static let xReducer = Reducer(\SelectedPlayers.x){
        PossiblePlayers.reducer
    }
    
    static let oReducer = Reducer(\SelectedPlayers.o){
        PossiblePlayers.reducer
    }
    
}
