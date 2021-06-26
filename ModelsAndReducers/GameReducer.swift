//
//  GameReducer.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 06.05.21.
//

import RedCat
import Foundation

// MARK: MODEL


enum GameStage : Equatable {
    case running(currentPlayer: Player)
    case tie
    case won(winner: Player, witness: VictoryWitness)
}


enum VictoryWitness : CaseIterable, Equatable {
    case row(Int)
    case col(Int)
    case diag1
    case diag2
    case otherPlayerHasWithdrawn
    static var allCases : [VictoryWitness] {
        (0..<3).map(VictoryWitness.row)
            + (0..<3).map(VictoryWitness.col)
            + [.diag1, .diag2, .otherPlayerHasWithdrawn]
    }
    var indices : [(row: Int, col: Int)] {
        switch self {
        case .row(let idx):
            return (0..<3).map {(idx, $0)}
        case .col(let idx):
            return (0..<3).map {($0, idx)}
        case .diag1:
            return (0..<3).map {($0, $0)}
        case .diag2:
            return (0..<3).map {(2 - $0, $0)}
        case .otherPlayerHasWithdrawn:
            return []
        }
    }
}


struct Board : Equatable {
    
    private var grid = [Player?](repeating: nil, count: 9)
    private(set) var stage : GameStage = .running(currentPlayer: .x)
    var lastSuccessfulMove : Move?
    var gameIsOver : Bool {
        switch stage {
        case .running:
            return false
        case .tie:
            return true
        case .won:
            return true
        }
    }
    
    var currentPlayer : Player? {
        guard case .running(let currentPlayer) = stage else {
            return nil
        }
        return currentPlayer
    }
    
    subscript(row row: Int, col col: Int) -> Player? {
        get {
            grid[col * 3 + row]
        }
        set {
            grid[col * 3 + row] = newValue
        }
    }
    
    struct Move : Equatable {
        let row : Int
        let col : Int
    }
    
}

// MARK: REDUCER

extension Board {
    
    static let reducer = BoardReducer()
    
    struct BoardReducer : ReducerProtocol {
        
        
        func apply(_ action: AppAction.Board,
                   to state: inout Board) {
            
            switch action {
            
            case .makeMove(player: let player, row: let row, col: let col):
                makeMove(player: player, row: row, col: col, board: &state)
                
            case .resign(player: let player):
                resign(player: player, from: &state)
                
            }
            
        }
        
        func resign(player: Player, from board: inout Board) {
            
            guard
                case .running = board.stage else {
                return
            }
            
        board.stage = .won(winner: player.other,
                               witness: .otherPlayerHasWithdrawn)
            
        }
        
        func makeMove(player: Player, row: Int, col: Int, board: inout Board) {
            // check that the came is running
            // and that the move is made by the right player
            
            guard
                case .running(let player) = board.stage,
                player == player else {
                return
            }
            
            // check that field is empty
            
            guard board[row: row, col: col] == nil else {
                return
            }
            
            // claim field and update last successful move
            
            board[row: row, col: col] = player
            board.lastSuccessfulMove = Move(row: row, col: col)
            
            // update game stage
            
            board.stage = endWithWinner(board) ??
                endWithTie(board) ??
                .running(currentPlayer: player.other)
        }
        
        
        
        func endWithTie(_ game: Board) -> GameStage? {
            !game.grid.contains(nil) ? .tie : nil
        }
        
        
        func endWithWinner(_ game: Board) -> GameStage? {
            for witness in VictoryWitness.allCases {
                let players = Set(witness.indices.map {game[row: $0, col: $1]})
                if players.count == 1,
                   !players.contains(nil) {
                    return .won(winner: players.compactMap {$0}.first!,
                                witness: witness)
                }
            }
            return nil
        }
        
    }
    
}
