//
//  PlayerDescriptors.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import Foundation
import RedCat

//MARK: Human

struct HumanPlayer : PlayerDescriptor {
    
    var title : String {
        "Human"
    }
    
    var description : String {
        "This is you!"
    }
    
    func makeMove(board: Board, makeMove: @escaping (RowCol) -> Void) {}
    
}

//MARK: RandomAI 

struct RandomAI : PlayerDescriptor {
    
    let player : Player
    var delayMs : Int
    
    init(player: Player, delayMs: Int = 200){
        self.player = player
        self.delayMs = delayMs
    }
    
    var title : String {
        "Random AI"
    }
    
    var description : String {
        "An AI that makes random moves with a delay of \(delayMs) milliseconds."
    }
    
    func makeMove(board: Board, makeMove: @escaping (RowCol) -> Void) {
        
        let possibleMoves = (0..<3).flatMap{i in
            (0..<3).map{j in (i,j)}
        }.filter{board[row: $0, col: $1] == nil}
        if let (i, j) = possibleMoves.randomElement() {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delayMs)) {
                makeMove(RowCol(row: i, col: j))
            }
        }
    }
    
    static let reducer = delayReducer
    
    static let delayReducer = Reducer {
        (action: Actions.ChangeDelay, state: inout RandomAI) in
        guard state.player == action.player else {return}
        state.delayMs = action.newValue
    }
    
}
