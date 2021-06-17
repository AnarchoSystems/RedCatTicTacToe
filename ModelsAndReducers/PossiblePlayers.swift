//
//  PossiblePlayers.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import RedCat
import CasePaths

// swiftlint:disable identifier_name


@dynamicMemberLookup
enum PossiblePlayers : Emptyable, Equatable {
    
    case human(HumanPlayer)
    case randomAI(RandomAI)
    
    static var empty : PossiblePlayers = .human(HumanPlayer())
    
    var player : PlayerDescriptor {
        switch self {
        case .human(let human):
            return human
        case .randomAI(let ai):
            return ai
        }
    }
    
    subscript<T>(dynamicMember member: KeyPath<PlayerDescriptor, T>) -> T {
        player[keyPath: member]
    }
    
}


protocol PlayerDescriptor {
    var title : String {get}
    var description : String {get}
    var rawPlayer : RawPlayer {get}
}

enum RawPlayer : String, Hashable, CaseIterable, Codable {
    case human
    case randomAI = "Random AI"
}

extension PossiblePlayers {
    init(rawPlayer: RawPlayer) {
        switch rawPlayer {
        case .human:
            self = .human(HumanPlayer())
        case .randomAI:
            self = .randomAI(RandomAI())
        }
    }
}
