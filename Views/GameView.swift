//
//  GameView.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import SwiftUI
import RedCat



struct GameView : View {
    
    @EnvironmentObject var store : CombineStore<AppState.AppReducer>
    let state : PlayingState
    
    var body : some View {
        GeometryReader {geo in
            VStack(spacing: 0) {
                stats
                    .padding()
                    .frame(width: geo.size.width,
                            height: 0.05 * geo.size.height)
                Divider()
                BoardView(playingState: state)
                    .padding(30)
                    .frame(width: geo.size.width,
                            height: 0.95 * geo.size.height)
            }
        }
    }
    
    var stats : some View {
        HStack {
            Text(stateText)
            Button("Restart") {
                store.send(Actions.StartGame(selection: state.players))
            }
        }
    }
    
    var stateText : String {
        switch state.board.stage {
        case .running(let currentPlayer):
            return "Current player: " + String(currentPlayer.rawValue)
        case .tie:
            return "Tie!"
        case .won(let winner, _):
            return "Winner: " + String(winner.rawValue)
        }
    }
    
}


struct GamePreview : PreviewProvider {
    static var previews : some View {
        GameView(state: PlayingState(board: Board(),
                                     players: players))
    }
    static var players : SelectedPlayers {
        SelectedPlayers()
    }
}
