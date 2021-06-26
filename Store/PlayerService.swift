//
//  PlayerService.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 06.05.21.
//

import Foundation
import RedCat


class PlayerService : DetailService<AppState, Board?, AppAction> {
    
    func extractDetail(from state: AppState) -> Board? {
        state.board
    }
    
    func onAppInit() {
        store.send(AppAction.goToMainMenu(store.state))
    }
    
    func onUpdate(newValue: Board?) {
        if
            let board = newValue,
            let player = board.currentPlayer,
            let playerDescriptor = store.state.currentPlayer {
            switch playerDescriptor {
            case .human:
                () // handled by UI
            case .randomAI(let ai): // swiftlint:disable:this identifier_name
                ai.makeMove(on: board,
                            player: player,
                            store: store)
            }
        }
    }
    
}


fileprivate extension RandomAI {
    
    func makeMove(on board: Board, player: Player, store: StoreStub<AppState, AppAction>) {
        let possibleMoves = (0..<3).flatMap {row in
            (0..<3).map {col in (row, col)}
        }.filter {board[row: $0, col: $1] == nil}
        if let (row, col) = possibleMoves.randomElement() {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delayMs)) {
                store.send(AppAction.board(action: .makeMove(player: player,
                                                             row: row,
                                                             col: col)))
            }
        }
    }
    
}
