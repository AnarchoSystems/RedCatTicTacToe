//
//  BoardView.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import SwiftUI
import RedCat


extension BoardView {
    init(board: Board) {
        var board = board
        board.lastModificationAttempt = Date()
        var players = SelectedPlayers()
        players.x = .randomAI(RandomAI(player: .x))
        players.o = .randomAI(RandomAI(player: .o))
        playingState = PlayingState(board: board,
                                    players: players)
    }
}

struct BoardView : View {
    
    @EnvironmentObject var store : CombineStore<AppState.AppReducer>
    
    let playingState : PlayingState
    
    var board : Board {
        playingState.board
    }
    
    var lastRow : Int? {
        board.lastSuccessfulMove?.row
    }
    
    var lastCol : Int? {
        board.lastSuccessfulMove?.col
    }
    
    var winningRowsCols : [(row: Int, col: Int)] {
        guard case .won(_, let witness) = board.stage else {
            return []
        }
        return witness.indices
    }
    
    var body: some View {
        GeometryReader{geo in
            let totalSize = min(geo.size.width,
                                geo.size.height)
            LazyVGrid(columns: gridItems(totalSize: totalSize)) {
                ForEach(0..<3){colIdx in
                    LazyHGrid(rows: gridItems(totalSize: totalSize)){
                        ForEach(0..<3){rowIdx in
                            cellView(row: rowIdx,
                                     col: colIdx)
                                .scaledToFill()
                        }
                    }
                }
            }
        }
    }
    
    func cellView(row: Int, col: Int) -> some View {
        CellButton(label: board[row: row, col: col]){
            attemptMove(row: row, col: col)
        }
        .foregroundColor(winningRowsCols.contains{row == $0 && col == $1} ? .red :
                            row == lastRow
                            && col == lastCol ?
                            .yellow :
                            .black)
    }
    
    func attemptMove(row: Int, col: Int) {
        
        for player in Player.allCases {
            
            if case .human = playingState.players[player],
               board.currentPlayer == player{
                
                store.send(Actions.MakeMove(player: player,
                                            row: row,
                                            col: col))
                
            }
        }
        
    }
    
    func gridItems(totalSize: CGFloat) -> [GridItem] {
        [GridItem](repeating: singleGridItem(size: totalSize / 3),
                   count: 3)
    }
    
    func singleGridItem(size: CGFloat) -> GridItem {
        GridItem(.fixed(size),
                 spacing: 0)
    }
    
}


extension CGRect {
    
    var center : CGPoint {
        CGPoint(x: (minX + maxX) / 2,
                y: (minY + maxY) / 2)
    }
    
}


struct BoardPreview : PreviewProvider {
    
    static var previews: some View {
        BoardView(board: board)
            .environmentObject(AppState.makeStore())
    }
    
    static var board : Board {
        var result = Board()
        result[row: 0, col: 0] = .x
        result[row: 0, col: 1] = .o
        result[row: 1, col: 1] = .x
        return result
    }
    
}
