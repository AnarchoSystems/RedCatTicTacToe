//
//  ResetService.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import Foundation
import RedCat


class ResetService : DetailService<AppState, Board?, AppAction> {
    
    func onUpdate(newValue: Board?) {
        guard
            case .mainMenu = store.state,
            let newValue = newValue else {return}
        switch newValue.stage {
        case .running:
            ()
        case .tie, .won:
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                guard case .mainMenu = self.store.state else {return}
                self.store.send(AppAction.goToMainMenu(self.store.state))
            }
        }
    }
    
    func extractDetail(from state: AppState) -> Board? {
        state.board
    }
    
}
