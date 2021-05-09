//
//  PlayerDispatchScreen.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import SwiftUI
import RedCat


struct PlayerDispatchScreen : View {
    
    let model : PossiblePlayers
    let player : Player
    
    @ViewBuilder
    var body: some View {
        switch model {
        case .human:
            Spacer()
        case .randomAI(let ai):
            AIModifyView(player: player,
                         ai: ai)
        }
    }
    
}


struct AIModifyView : View {
    
    @EnvironmentObject var store : CombineStore<AppState.AppReducer>
    @Environment(\.undoManager) var undoManager
    let player : Player
    let ai : RandomAI
    
    var value : Binding<Float> {
        Binding(get: {Float(ai.delayMs)},
                set: {store.sendWithUndo(action($0),
                                         undoManager: undoManager)})
    }
    
    func action(_ newValue: Float) -> some Undoable {
        Actions.ChangeDelay(player: player,
                            oldValue: ai.delayMs,
                            newValue: Int(newValue))
    }
    
    var body: some View {
        HStack {
        Slider(value: value, in: 0...1000){
            Text("Delay")
        }
            Text("\(ai.delayMs)ms")
        }
        .padding(.horizontal, 15)
        .padding()
    }
    
}


struct PlayerDispatchPreview : PreviewProvider {
    
    static var previews: some View {
        AIModifyView(player: .x,
                     ai: RandomAI(player: .x))
            .environmentObject(AppState.makeStore())
    }
    
}
