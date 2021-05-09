//
//  ResetService.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import Foundation
import RedCat


class ResetService : DetailService<AppState, Board?> {
    
    override func onUpdate(newValue: Board?, store: Store<AppState>, environment: Dependencies) {
        guard
            case .mainMenu = store.state,
            let newValue = newValue else {return}
        switch newValue.stage {
        case .running:
            ()
        case .tie, .won:
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
                guard case .mainMenu = store.state else{return}
                store.send(Actions.goToMainMenu(store.state))
            }
        }
    }
    
}
