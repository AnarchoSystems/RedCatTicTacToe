//
//  Statistics.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import Foundation
import RedCat


// MARK: Model

struct GameStats : Codable {
    
    let key : GameStatsKey
    
    var wins : [GameStatsKey : Int] = [:]
    var losses : [GameStatsKey : Int] = [:]
    var ties : [GameStatsKey : Int] = [:]
    
}


struct GameStatsKey : Hashable, Codable {
    
    let player : Player
    let rawPlayer : RawPlayer
    
    var string : String {
        rawPlayer.rawValue + "/" + String(player.rawValue)
    }
    
}


extension AppState {
    
    
    subscript(gameStatsFor statsKey: GameStatsKey) -> GameStats {
        get {
            UserDefaults.standard.data(forKey: statsKey.string)
                .flatMap {try? JSONDecoder().decode(GameStats.self, from: $0)}
            ?? GameStats(key: statsKey)
        }
        set {
            // swiftlint:disable:next force_try
            let data = try! JSONEncoder().encode(newValue)
            UserDefaults.standard.setValue(data, forKey: statsKey.string)
        }
    }
    
    // MARK: Reducers
    
    static let recordGameResultReducer = Reducer {
        recordWinReducer.compose(with: recordTieReducer)
    }
    
    fileprivate static let recordWinReducer = Reducer {
        (action: Actions.RecordWin, state: inout AppState) in
        state[gameStatsFor: action.winner].wins[action.loser].modify(default: 1, inc)
        state[gameStatsFor: action.loser].losses[action.winner].modify(default: 1, inc)
    }
    
    fileprivate static let recordTieReducer = Reducer {
        (action: Actions.RecordTie, state: inout AppState) in
        state[gameStatsFor: action.player1].ties[action.player2].modify(default: 1, inc)
        state[gameStatsFor: action.player2].ties[action.player1].modify(default: 1, inc)
    }
    
}

// MARK: Helpers

fileprivate func inc(_ num: inout Int) {
    num += 1
}

extension Optional {
    
    mutating func modify(default defaultValue: Wrapped? = nil, _ closure: (inout Wrapped) -> Void) {
        guard var some = self else {
            self = defaultValue
            return
        }
        self = nil
        closure(&some)
        self = some
    }
    
}
