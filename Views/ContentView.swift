//
//  ContentView.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 06.05.21.
//

import SwiftUI
import RedCat
import CasePaths


struct ContentView: View {
    
    @StateObject var store : CombineStore<AppState, AppAction> = AppState.makeStore()
    
    @ViewBuilder
    var body: some View {
        dispatchView
            .environmentObject(store)
            .frame(minWidth: 1000,
                   minHeight: 1000)
    }
    
    @ViewBuilder
    var dispatchView : some View {
        switch store.state {
        case .mainMenu(let board):
            ZStack {
                menuBackground(board).disabled(true)
                MainMenu()
            }
        case .lobby:
            nonMenuScreen(SetUpScreen())
        case .hallOfFame:
            nonMenuScreen(HallOfFame())
        case .playing:
            nonMenuScreen(GameView())
        }
    }
    
    func nonMenuScreen<V : View>(_ view: V) -> some View {
        GeometryReader {geo in
            VStack(spacing: 0) {
                Button("Main menu",
                       action: backToMainMenu)
                    .frame(width: geo.size.width,
                           height: 0.1 * geo.size.height)
                view
                    .frame(width: geo.size.width,
                           height: 0.9 * geo.size.height)
            }
        }
    }
    
    func backToMainMenu() {
        store.send(AppAction.goToMainMenu(store.state))
    }
    
    
    func menuBackground(_ board: Board) -> some View {
        return BoardView()
            .padding()
            .blur(radius: 3)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
