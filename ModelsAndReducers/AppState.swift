//
//  AppState.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 06.05.21.
//

import RedCat
import CasePaths

struct PlayingState : Equatable {
    
    var board : Board
    var players : SelectedPlayers
    
}

enum AppState : Emptyable {
    
    case empty
    case mainMenu(Board)
    case hallOfFame
    case lobby(SelectedPlayers)
    case playing(PlayingState)
    
    static func makeStore() -> CombineStore<AppState, AppAction> {
        Store(initialState: .empty,
              erasing: reducer,
              environment: [],
              services: [PlayerService(),
                         RecordGameService(),
                         ResetService()])
    }
    
    var board : Board? {
        get {
            switch self {
            case .mainMenu(let board):
                return board
            case .empty, .lobby, .hallOfFame:
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
            case .empty, .lobby, .hallOfFame:
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
        case .empty, .lobby, .hallOfFame:
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
                return ConfigReducer().send(action)
                
            case .stats(action: let action):
                return StatsReducer().send(action)
            }
            
        }
        
    }
    
    struct ConfigReducer : DispatchReducerProtocol {
        
        func dispatch(_ action: AppAction.GameConfig) -> VoidReducer<AppState> {
            
            switch action {
            case .configure(action: let action):
                return SelectedPlayers
                    .reducer
                    .bind(to: /AppState.lobby)
                    .send(action)
                
            case .start(selection: let selection):
                return startGameReducer
                    .send(selection)
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
