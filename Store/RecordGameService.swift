//
//  RecordGameService.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import RedCat
import Foundation



class RecordGameService : Service<AppState> {
    
    var lastMove : Date?
    
    override func afterUpdate<Action>(store: Store<AppState>, action: Action, environment: Dependencies) {
        guard
            case .playing(let state) = store.state,
            state.board.lastModification != lastMove else{
            return
        }
        lastMove = state.board.lastModification
        switch state.board.stage {
        case .running:
            ()
        case .tie:
            store.send(Actions.RecordTie(p1: GameStatsKey(player: .x,
                                                          rawPlayer: state.players.x.rawPlayer),
                                         p2: GameStatsKey(player: .o,
                                                          rawPlayer: state.players.o.rawPlayer)))
        case .won(let winner, _):
            store.send(Actions.RecordWin(winner: GameStatsKey(player: winner,
                                                              rawPlayer: state.players[winner].rawPlayer),
                                         loser: GameStatsKey(player: winner.other,
                                                             rawPlayer: state.players[winner.other].rawPlayer)))
        }
    }
    
}
