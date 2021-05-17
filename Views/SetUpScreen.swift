//
//  SetUpScreen.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 07.05.21.
//

import SwiftUI
import RedCat



struct SetUpScreen : View {
    
    @EnvironmentObject var store : CombineStore<AppState>
    
    func viewState(_ appState: AppState) -> SelectedPlayers {
        guard case .lobby(let players) = appState else {
           return SelectedPlayers()
        }
        return players
    }
    
    var body: some View {
        
        store.withViewStore(viewState) {store in
            
            GeometryReader {geo in
                VStack(spacing: 0) {
                    players(store.state)
                        .frame(width: geo.size.width,
                               height: 0.9 * geo.size.height)
                    startButton(store.state)
                        .frame(width: geo.size.width,
                               height: 0.1 * geo.size.height)
                }
            }
        }
        
    }
    
    func players(_ selection: SelectedPlayers) -> some View {
        
        GeometryReader {geo in
            HStack(spacing: 0) {
                PlayerScreen(player: .x,
                             selection: selection)
                    .padding()
                    .frame(width: 0.5 * geo.size.width,
                           height: geo.size.height)
                Divider()
                PlayerScreen(player: .o,
                             selection: selection)
                    .padding()
                    .frame(width: 0.5 * geo.size.width,
                           height: geo.size.height)
            }
        }
        
    }
    
    func startButton(_ selection: SelectedPlayers) -> some View {
        Button("Start!") {
            start(with: selection)
        }
    }
    
    func start(with selection: SelectedPlayers) {
        store.send(Actions.GameConfig.StartGame(selection: selection))
    }
    
}


struct SetUpPreview : PreviewProvider {
    
    static var previews: some View {
        SetUpScreen()
            .environmentObject(AppState.makeStore())
    }
    
}
