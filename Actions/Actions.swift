//
//  Actions.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import RedCat


extension Actions {
    
    enum Board {
        
        struct MakeMove : ActionProtocol, Equatable {
            let player : Player
            let row : Int
            let col : Int
        }
        
        struct Resign : ActionProtocol {
            let player : Player
        }
        
    }
    
    
    enum Menu {
        
        struct SetUpGame : ActionProtocol {}
        
        struct GoToHallOfFame : ActionProtocol {}
        
        struct GoToMainMenu : ActionProtocol {
            fileprivate init() {}
        }
        
        
        static func goToMainMenu(_ appState: AppState) -> (Board.Resign?, GoToMainMenu) {
            
            if
                case .playing(let state) = appState {
                if case .human = state.players.x {
                    return (Board.Resign(player: .x), GoToMainMenu())
                }
                else if case .human = state.players.o {
                    return (Board.Resign(player: .o), GoToMainMenu())
                }
            }
            
            return (nil, GoToMainMenu())
            
            
        }
        
    }
    
    enum GameConfig {
        
        struct StartGame : ActionProtocol {
            let selection : SelectedPlayers
        }
        
        struct SelectPlayer : Undoable {
            let player : Player
            var oldValue : PossiblePlayers
            var newValue : PossiblePlayers
            mutating func invert() {
                (oldValue, newValue) = (newValue, oldValue)
            }
        }
        
        struct ChangeDelay : Undoable, ActionForPlayer {
            let player : Player
            var oldValue : Int
            var newValue : Int
            mutating func invert() {
                (oldValue, newValue) = (newValue, oldValue)
            }
        }
        
    }
    
    enum Stats {
        
        struct RecordWin : ActionProtocol {
            
            let winner : GameStatsKey
            let loser : GameStatsKey
            
        }
        
        struct RecordTie : ActionProtocol {
            
            let player1 : GameStatsKey
            let player2 : GameStatsKey
            
        }
        
    }
    
}
