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
    
    // swiftlint:disable identifier_name
    var x : PossiblePlayers = .human(HumanPlayer())
    var o : PossiblePlayers = .randomAI(RandomAI(player: .o))
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
    
    static let reducer = selectPlayerReducer
        .compose(with: PossiblePlayers.reducer, property: \.x)
        .compose(with: PossiblePlayers.reducer, property: \.o)
    
    
    static let selectPlayerReducer = Reducer {
        Reducer {
            (action: Actions.SelectPlayer, state: inout SelectedPlayers) in
            state[action.player] = action.newValue
        }
    }
    
}
