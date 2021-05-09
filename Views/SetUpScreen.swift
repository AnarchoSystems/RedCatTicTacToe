//
//  SetUpScreen.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 07.05.21.
//

import SwiftUI
import RedCat



struct SetUpScreen : View {
    
    @EnvironmentObject var store : CombineStore<AppState.AppReducer>
    let selection : SelectedPlayers
    
    var body: some View {
        
        GeometryReader {geo in
            VStack(spacing: 0) {
                players
                    .frame(width: geo.size.width,
                           height: 0.9 * geo.size.height)
                startButton
                    .frame(width: geo.size.width,
                           height: 0.1 * geo.size.height)
            }
        }
        
    }
    
    var players : some View {
        
        GeometryReader{geo in
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
    
    var startButton : some View {
            Button("Start!",
                   action: start)
    }
    
    func start() {
        store.send(Actions.StartGame(selection: selection))
    }
    
}


struct SetUpPreview : PreviewProvider {
    
    static var previews: some View {
        SetUpScreen(selection: SelectedPlayers())
            .environmentObject(AppState.makeStore())
    }
    
}
