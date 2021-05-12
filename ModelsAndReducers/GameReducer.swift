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


public struct Board : Equatable {
    
    private var grid = [Player?](repeating: nil, count: 9)
    private(set) var stage : GameStage = .running(currentPlayer: .x)
    var lastSuccessfulMove : Actions.MakeMove?
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
    
}

// MARK: REDUCER

extension Board {
    
    static let reducer = BoardReducer()
    
    struct BoardReducer : ReducerWrapper {
        
        let body =  MoveReducer()
            .compose(with: resignReducer)
        
    }
    
    static let resignReducer = Reducer {
        (action: Actions.Resign, state: inout Board) in
            
            guard
                case .running = state.stage else {
                return
            }
            
        state.stage = .won(winner: action.player.other,
                               witness: .otherPlayerHasWithdrawn)
            
        
    }
    
    struct MoveReducer : ReducerProtocol {
       
        typealias Action = Actions.MakeMove
        typealias State = Board
        
        func apply(_ action: Actions.MakeMove, to state: inout Board) {
            
            // check that the came is running
            // and that the move is made by the right player
            
            guard
                case .running(let player) = state.stage,
                player == action.player else {
                return
            }
            
            // check that field is empty
            
            guard state[row: action.row, col: action.col] == nil else {
                return
            }
            
            // claim field and update last successful move
            
            state[row: action.row, col: action.col] = player
            state.lastSuccessfulMove = action
            
            // update game stage
            
            state.stage = endWithWinner(state) ??
                endWithTie(state) ??
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
