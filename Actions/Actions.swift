//
//  Actions.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import RedCat


enum Actions {
    
    struct MakeMove : ActionProtocol, Equatable {
        let player : Player
        let row : Int
        let col : Int
    }

    struct Resign : ActionProtocol {
        let player : Player
    }
    
    struct SelectPlayer : Undoable {
        let player : Player
        var oldValue : PossiblePlayers
        var newValue : PossiblePlayers
        mutating func invert() {
            (oldValue, newValue) = (newValue, oldValue)
        }
    }
    
    struct SetUpGame : ActionProtocol{}
    
    struct StartGame : ActionProtocol{
        let selection : SelectedPlayers
    }
    
    struct GoToMainMenu : ActionProtocol{
        fileprivate init(){}
    }
    
    @ActionBuilder
    static func goToMainMenu(_ appState: AppState) -> some ActionProtocol {
        
        if
            case .playing(let state) = appState {
            if case .human = state.players.x {
                Actions.Resign(player: .x)
            }
            if case .human = state.players.o {
                Actions.Resign(player: .o)
            }
        }
        
        Actions.GoToMainMenu()
        
    }
    
    struct ChangeDelay : Undoable {
        let player : Player
        var oldValue : Int
        var newValue : Int
        mutating func invert() {
            (oldValue, newValue) = (newValue, oldValue)
        }
    }
    
    struct RecordWin : ActionProtocol {
        
        let winner : GameStatsKey
        let loser : GameStatsKey
        
    }
    
    struct RecordTie : ActionProtocol {
        
        let p1 : GameStatsKey
        let p2 : GameStatsKey
        
    }
    
    struct GoToHallOfFame : ActionProtocol{}
    
}
