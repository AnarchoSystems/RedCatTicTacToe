//
//  PlayerService.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 06.05.21.
//

import RedCat


struct RowCol {
    let row : Int
    let col : Int
}


protocol PlayerDescriptor {
    var title : String {get}
    var description : String {get}
    // to be called by services -- sideeffects allowed, direct mutation disallowed
    func makeMove(board: Board, makeMove: @escaping (RowCol) -> Void)
}


class PlayerService : DetailService<AppState, Board?> {
    
    override func onUpdate(newValue: Board?,
                           store: Store<AppState>,
                           environment: Dependencies) {
        if
            let board = newValue,
            let player = board.currentPlayer {
            store.state.currentPlayer?
                .makeMove(board: board) {rowCol in
                    store.send(Actions.MakeMove(player: player,
                                                row: rowCol.row,
                                                col: rowCol.col))
                }
        }
    }
    
}
