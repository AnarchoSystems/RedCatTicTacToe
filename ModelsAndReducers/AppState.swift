//
//  AppState.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 06.05.21.
//

import RedCat
import CasePaths

struct PlayingState {
    
    var board : Board
    var players : SelectedPlayers
    
}

enum AppState : Emptyable {
    
    case mainMenu(Board)
    case hallOfFame
    case lobby(SelectedPlayers)
    case playing(PlayingState)
    
    static let empty : AppState = .mainMenu(Board())
    
    static func makeStore() -> CombineStore<AppReducer> {
        Store.combineStore(initialState: .mainMenu(Board()),
                           reducer: reducer,
                           environment: [:],
                           services: [PlayerService(detail: \.board),
                                      RecordGameService(),
                                      ResetService(detail: \.board)])
    }
    
    static let reducer = AppReducer()
    
    struct AppReducer : ReducerWrapper {
        
        let body = Reducer {
            playingReducer
                .compose(with: lobbyReducer)
                .compose(with: gotoMainMenuReducer)
                .compose(with: goToHallOfFameReducer)
                .compose(with: startGameReducer)
                .compose(with: setUpReducer)
                .compose(with: mainMenuBackgroundBoardReducer)
                .compose(with: recordGameResultReducer)
                .handlingLists()
        }
        
    }
    
    var board : Board? {
        switch self {
        case .mainMenu(let board):
            return board
        case .lobby, .hallOfFame:
            return nil
        case .playing(let state):
            return state.board
        }
    }
    
    var currentPlayer : PlayerDescriptor? {
        switch self {
        case .mainMenu(let board):
            return board.currentPlayer.map{RandomAI(player: $0)}
        case .lobby, .hallOfFame:
            return nil
        case .playing(let state):
            return state.board.currentPlayer.map{state.players[$0].player}
        }
    }
    
    static let goToHallOfFameReducer = Reducer {
        (action: Actions.GoToHallOfFame, state: inout AppState) in
        state = .hallOfFame
    }
    
    static let mainMenuBackgroundBoardReducer = Reducer(/AppState.mainMenu) {
        Board.reducer
    }
    
    static let setUpReducer = Reducer {
        (action: Actions.SetUpGame, state: inout AppState) in
        state = .lobby(SelectedPlayers())
    }
    
    static let startGameReducer = Reducer {
        (action: Actions.StartGame, state: inout AppState) in
        state = .playing(PlayingState(board: Board(), players: action.selection))
    }
    
    static let playingReducer = Reducer(/AppState.playing) {
        Reducer(\.board){
            Board.reducer
        }
    }
    
    static let lobbyReducer = Reducer(/AppState.lobby) {
        SelectedPlayers.reducer
    }
    
    static let gotoMainMenuReducer = Reducer {
        (action: Actions.GoToMainMenu, state: inout AppState) in
        state = .mainMenu(Board())
    }
    
}
