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
    
    static func makeStore() -> CombineStore<AppState, AppAction> {
        Store.combineStore(initialState: .mainMenu(Board()),
                           reducer: reducer,
                           environment: [],
                           services: [PlayerService(detail: \.board),
                                      RecordGameService(),
                                      ResetService(detail: \.board)])
    }
    
    var board : Board? {
        get {
            switch self {
            case .mainMenu(let board):
                return board
            case .lobby, .hallOfFame:
                return nil
            case .playing(let state):
                return state.board
            }
        }
        set {
            guard let newValue = newValue else {return}
            switch self {
            case .mainMenu(var board):
                self = .empty
                board = newValue
                self = .mainMenu(board)
            case .lobby, .hallOfFame:
                return
            case .playing(var state):
                self = .empty
                state.board = newValue
                self = .playing(state)
            }
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
    
    struct AppReducer : DispatchReducerProtocol {
        
        func dispatch(_ action: AppAction) -> VoidReducer<AppState> {
            switch action {
            case .board(action: let action):
                return Board.reducer
                    .bind(to: /Optional.some)
                    .bind(to: \AppState.board)
                    .send(action)
            case .menu(action: let action):
                return MenuReducer().send(action)
            case .gameConfig(action: let action):
                switch action {
                case .configure(action: let action):
                    return SelectedPlayers.reducer.bind(to: /AppState.lobby).send(action)
                case .start(selection: let selection):
                    return startGameReducer.send(selection)
                }
            case .stats(action: let action):
                return StatsReducer().send(action)
            }
        }
        
    }
    
    
    struct MenuReducer : ReducerProtocol {
        
        func apply(_ action: AppAction.Menu,
                   to state: inout AppState) {
            switch action {
            case .setUp:
                state = .lobby(SelectedPlayers())
            case .goToHallOfFame:
                state = .hallOfFame
            case .main:
                state = .mainMenu(Board())
            }
        }
        
    }
    
    static let startGameReducer = Reducer {
        (action: SelectedPlayers, state: inout AppState) in
        state = .playing(PlayingState(board: Board(), players: action))
    }
    
}
