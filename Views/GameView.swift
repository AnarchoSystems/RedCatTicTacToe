//
//  GameView.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import SwiftUI
import RedCat



struct GameView : View {
    
    @EnvironmentObject var store : CombineStore<AppState, AppAction>
    
    func viewState(_ appState: AppState) -> PlayingState {
        guard case .playing(let state) = appState else {
            return PlayingState(board: Board(),
                                players: SelectedPlayers())
        }
        return state
    }
    
    var body : some View {
        
        store.withViewStore(onAction: AppAction.board,
                            viewState) {store in
            GeometryReader {geo in
                VStack(spacing: 0) {
                    stats(stage: store.state.board.stage,
                          players: store.state.players)
                        .padding()
                        .frame(width: geo.size.width,
                               height: 0.05 * geo.size.height)
                    Divider()
                    BoardView()
                        .padding(30)
                        .frame(width: geo.size.width,
                               height: 0.95 * geo.size.height)
                }
            }
        }
    }
    
    func stats(stage: GameStage,
               players: SelectedPlayers) -> some View {
        HStack {
            Text(stateText(stage))
            Button("Restart") {
                store.send(.gameConfig(action: .start(selection: players)))
            }
        }
    }
    
    func stateText(_ stage: GameStage) -> String {
        switch stage {
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
        GameView()
    }
    static var players : SelectedPlayers {
        SelectedPlayers()
    }
}
