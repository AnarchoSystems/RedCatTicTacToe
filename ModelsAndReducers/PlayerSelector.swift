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
    
    static let reducer = selectPlayerReducer
        .compose(with: AIReducer())
    
    
    static let selectPlayerReducer = Reducer {
        Reducer {
            (action: Actions.SelectPlayer, state: inout SelectedPlayers) in
            state[action.player] = action.newValue
        }
    }
    
    struct AIReducer : ErasedReducer {
        
        let wrapped = Reducer(/PossiblePlayers.randomAI) {
            RandomAI.reducer
        }
        
        func apply<Action : ActionProtocol>(_ action: Action,
                                            to state: inout SelectedPlayers,
                                            environment: Dependencies) {
            if let actionForPlayer = action as? ActionForPlayer {
                switch actionForPlayer.player {
                case .x:
                    wrapped.apply(action, to: &state.x, environment: environment)
                case .o:
                    wrapped.apply(action, to: &state.o, environment: environment)
                }
            }
            else {
                wrapped.apply(action, to: &state.x, environment: environment)
                wrapped.apply(action, to: &state.o, environment: environment)
            }
        }
        
        func acceptsAction<Action>(ofType type: Action.Type) -> Bool where Action : ActionProtocol {
            RandomAI.reducer.acceptsAction(ofType: type)
        }
        
        
    }
    
}


protocol ActionForPlayer {
    var player : Player {get}
}
