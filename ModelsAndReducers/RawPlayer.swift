//
//  RawPlayer.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//


enum RawPlayer : String, Hashable, CaseIterable, Codable {
    case human
    case randomAI = "Random AI"
}

extension PossiblePlayers {
    init(rawPlayer: RawPlayer, player: Player) {
        switch rawPlayer {
        case .human:
            self = .human(HumanPlayer())
        case .randomAI:
            self = .randomAI(RandomAI(player: player))
        }
    }
    var rawPlayer : RawPlayer {
        switch self {
        case .human:
            return .human
        case .randomAI:
            return .randomAI
        }
    }
}
