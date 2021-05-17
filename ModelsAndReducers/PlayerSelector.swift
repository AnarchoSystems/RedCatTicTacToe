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
    
    typealias Actions = RedCat.Actions.GameConfig
    
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
    
    struct AIReducer : DispatchReducer {
        
        typealias PartReducer = DetailReducer<SelectedPlayers, AspectReducer<PossiblePlayers, RandomAI.AIReducer>>
        typealias Result = IfReducer<PartReducer, BothAIReducer>
        
        func dispatch<Action : ActionProtocol>(_ action: Action) -> Result {
            
            (action as? ActionForPlayer)
                .map(partReducer)
                .map(IfReducer.ifReducer) ??
                .elseReducer(BothAIReducer())
            
        }
        
        func partReducer(for action: ActionForPlayer) -> PartReducer {
            DetailReducer(\SelectedPlayers.[action.player]) {
                AspectReducer(/PossiblePlayers.randomAI) {
                    RandomAI.AIReducer()
                }
            }
        }
        
    }
    
    struct BothAIReducer : ReducerWrapper {
        
        let body = Reducer(\SelectedPlayers.x) {
            Self.aiReducer
        }.compose(with: Self.aiReducer, property: \SelectedPlayers.o)
        
        static var aiReducer : Reducer<AspectReducer<PossiblePlayers, RandomAI.AIReducer>> {
            Reducer(/PossiblePlayers.randomAI) {
                RandomAI.AIReducer()
            }
        }
        
    }
    
}


protocol ActionForPlayer {
    var player : Player {get}
}
