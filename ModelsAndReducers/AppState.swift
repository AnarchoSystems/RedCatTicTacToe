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
    
    static func makeStore() -> CombineStore<AppState> {
        Store.combineStore(initialState: .mainMenu(Board()),
                           reducer: reducer,
                           environment: [],
                           services: [UnrecognizedActionDebugger(trapOnDebug: true),
                                      PlayerService(detail: \.board),
                                      RecordGameService(),
                                      ResetService(detail: \.board)])
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
    
    var currentPlayer : PossiblePlayers? {
        switch self {
        case .mainMenu:
            return .randomAI(RandomAI())
        case .lobby, .hallOfFame:
            return nil
        case .playing(let state):
            return state.board.currentPlayer.map {state.players[$0]}
        }
    }
    
    
    static let reducer = AppReducer()
    
    struct AppReducer : ReducerWrapper {
        
        @usableFromInline
        let body = AnyReducer(
            gotoMainMenuReducer
                .compose(with: playingReducer)
                .compose(with: SelectedPlayers.reducer, aspect: /AppState.lobby)
                .compose(with: goToHallOfFameReducer)
                .compose(with: startGameReducer)
                .compose(with: setUpReducer)
                .compose(with: mainMenuBackgroundBoardReducer)
                .compose(with: recordGameResultReducer)
        )
        
    }
    
    static let goToHallOfFameReducer = Reducer {
        (_: Actions.Menu.GoToHallOfFame, state: inout AppState) in
        state = .hallOfFame
    }
    
    static let mainMenuBackgroundBoardReducer = Reducer(/AppState.mainMenu) {
        Board.reducer
    }
    
    static let setUpReducer = Reducer {
        (_: Actions.Menu.SetUpGame, state: inout AppState) in
        state = .lobby(SelectedPlayers())
    }
    
    static let startGameReducer = Reducer {
        (action: Actions.GameConfig.StartGame, state: inout AppState) in
        state = .playing(PlayingState(board: Board(), players: action.selection))
    }
    
    static let playingReducer = Reducer(/AppState.playing) {
        Reducer(\.board) {
            Board.reducer
        }
    }
    
    static let gotoMainMenuReducer = Reducer {
        (_: Actions.Menu.GoToMainMenu, state: inout AppState) in
        state = .mainMenu(Board())
    }
    
}
