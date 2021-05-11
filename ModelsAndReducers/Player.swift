//
//  Player.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

// swiftlint:disable identifier_name

enum Player : String, Hashable, CaseIterable, Codable {
    case x = "X"
    case o = "O"
    var other : Player {
        switch self {
        case .x:
            return .o
        case .o:
            return .x
        }
    }
}
