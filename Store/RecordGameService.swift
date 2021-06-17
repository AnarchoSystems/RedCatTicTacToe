//
//  RecordGameService.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import RedCat
import Foundation



class RecordGameService : DetailService<AppState, PlayingState?, AppAction> {
    
    var gameWasOver = false
    
    init() {
        super.init {
            guard case .playing(let state) = $0 else {return nil}
            return state
        }
    }
    
    override func onUpdate(newValue: PlayingState?) {
        guard
            let state = newValue,
            state.board.gameIsOver else {
            gameWasOver = false
            return
        }
        guard !gameWasOver else {
            return
        }
        gameWasOver = true
        
        switch state.board.stage {
        case .running:
            ()
        case .tie:
            store.send(AppAction.stats(action: .recordTie(player1: GameStatsKey(player: .x,
                                                                     rawPlayer: state.players.x.rawPlayer),
                                               player2: GameStatsKey(player: .o,
                                                                     rawPlayer: state.players.o.rawPlayer))))
        case .won(let winner, _):
            store.send(AppAction.stats(action: .recordWin(winner: GameStatsKey(player: winner,
                                                                    rawPlayer: state.players[winner].rawPlayer),
                                               loser: GameStatsKey(player: winner.other,
                                                                   rawPlayer: state.players[winner.other].rawPlayer))))
        }
    }
    
}
