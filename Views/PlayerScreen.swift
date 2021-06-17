//
//  PlayerScreen.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 07.05.21.
//

import SwiftUI
import RedCat



struct PlayerScreen : View {
    
    let player : Player
    @EnvironmentObject var store : CombineStore<AppState, AppAction>
    let selection : SelectedPlayers
    @Environment(\.undoManager) var undoManager
    
    var body: some View {
        
        GeometryReader {geo in
            VStack(spacing: 0) {
                title
                    .frame(width: geo.size.width,
                           height: 0.15 * geo.size.height)
                selector
                    .frame(width: geo.size.width,
                           height: 0.20 * geo.size.height)
                PlayerDispatchScreen(model: selection[player],
                                     player: player)
                    .frame(width: geo.size.width,
                           height: 0.20 * geo.size.height)
                description
                    .frame(width: geo.size.width,
                           height: 0.45 * geo.size.height)
            }
        }
        
    }
    
    func selectPlayer(_ rawPlayer: RawPlayer, player: Player) {
        let newValue = PossiblePlayers(rawPlayer: rawPlayer)
        let action = AppAction.GameConfig.ConfigAction.selectPlayer(player: player,
                                                                    oldValue: selection[player],
                                                                    newValue: newValue)
        store.sendWithUndo(action,
                           undoManager: undoManager) {
            AppAction.gameConfig(action: .configure(action: $0))
           }
    }
    
    var binding : Binding<RawPlayer> {
        Binding(get: {selection[player].rawPlayer},
                set: {selectPlayer($0, player: player)})
    }
    
    var title : some View {
        VStack(spacing: 0) {
            Text(String(player.rawValue))
                .font(.largeTitle)
                .padding()
            Divider()
        }
    }
    
    var selector : some View {
        Picker("Player",
               selection: binding) {
            ForEach(RawPlayer.allCases, id: \.self) {rawPlayer in
                Text(rawPlayer.rawValue)
            }
        }
    }
    
    
    var description : some View {
        GeometryReader {geo in
            Text(selection[player].description)
                .frame(width: geo.size.width,
                       height: geo.size.height)
        }
        .border(Color.black, width: 2)
        .padding(.vertical, 30)
        .padding(.horizontal, 50)
    }
    
}


struct PlayerScreenPreview : PreviewProvider {
    
    static var previews: some View {
        let players = SelectedPlayers()
        return PlayerScreen(player: .x,
                            selection: players)
            .environmentObject(AppState.makeStore())
    }
    
}
