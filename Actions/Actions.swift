//
//  Actions.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import RedCat


enum AppAction {
    
    case board(action: Board)
    case menu(action: Menu)
    case gameConfig(action: GameConfig)
    case stats(action: Stats)
    
    static func goToMainMenu(_ appState: AppState) -> ActionGroup<AppAction> {
        
        if
            case .playing(let state) = appState {
            if case .human = state.players.x {
                return [.board(action: .resign(player: .x)), .menu(action: .main)]
            }
            else if case .human = state.players.o {
                return [.board(action: .resign(player: .o)), .menu(action: .main)]
            }
        }
        
        return [.menu(action: .main)]
        
    }
    
}

extension AppAction {

    enum Board {
        
        case makeMove(player: Player, row: Int, col: Int)
        case resign(player: Player)
        
    }
    
    
    enum Menu : SequentiallyComposable {
        
        case setUp
        case goToHallOfFame
        case main
        
    }
    
    enum GameConfig {
        
        case configure(action: ConfigAction)
        case start(selection: SelectedPlayers)
        
        enum ConfigAction : Undoable {
            
            case selectPlayer(player: Player, oldValue: PossiblePlayers, newValue: PossiblePlayers)
            case changeAIDelay(player: Player, oldValue: Int, newValue: Int)
         
            mutating func invert() {
                switch self {
                case .selectPlayer(player: let player, oldValue: let oldValue, newValue: let newValue):
                    self = .selectPlayer(player: player, oldValue: newValue, newValue: oldValue)
                case .changeAIDelay(player: let player, oldValue: let oldValue, newValue: let newValue):
                    self = .changeAIDelay(player: player, oldValue: newValue, newValue: oldValue)
                }
            }
            
        }
        
    }
    
    enum Stats {
        
        case recordWin(winner: GameStatsKey, loser: GameStatsKey)
        case recordTie(player1: GameStatsKey, player2: GameStatsKey)
        
    }
    
}
