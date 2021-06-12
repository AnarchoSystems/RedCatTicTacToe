//
//  HallOfFame.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import SwiftUI
import RedCat


struct HallOfFame : View {
    
    @EnvironmentObject var store : CombineStore<AppState, AppAction>
    
    var body : some View {
        GeometryReader {geo in
            VStack(spacing: 0) {
                Text("HALL OF FAME")
                    .font(.largeTitle)
                    .padding()
                    .frame(width: geo.size.width,
                           height: 0.15 * geo.size.height)
                Divider().padding(.horizontal)
                items
                    .frame(width: geo.size.width,
                           height: 0.85 * geo.size.height)
            }
        }
    }
    
    var items : some View {
        
        HStack(spacing: 0) {
            ForEach(0..<oKeys.count + 1) {colIdx in
                VStack(spacing: 0) {
                    ForEach(0..<xKeys.count + 1) {rowIdx in
                        ZStack {
                            if colIdx == 0 && rowIdx == 0 {
                                angle.scaledToFit()
                            }
                            else {
                            cellBackground
                            }
                        extendedCell(rowIdx,
                                     colIdx)
                        }.frame(minWidth: 100,
                                minHeight: 100)
                    }
                }
            }
        }
        .padding(30)
        
    }
    
    @ViewBuilder
    func extendedCell(_ rowIdx: Int, _ colIdx: Int) -> some View {
        
        // swiftlint:disable identifier_name
        switch (rowIdx, colIdx) {
        
        case (0, 0):
            cornerView
        case (0, let o):
            Text(oKeys[o - 1].rawPlayer.rawValue)
        case (let x, 0):
            Text(xKeys[x - 1].rawPlayer.rawValue)
        default:
            cell(key1: xKeys[rowIdx - 1],
                 key2: oKeys[colIdx - 1])
            
        }
        // swiftlint:enable identifier_name
        
        
    }
    
    var angle : some View {
        GeometryReader {geo in
            let rect = geo.frame(in: .local).insetBy(dx: 5,
                                                     dy: 5)
            Path {path in
                path.move(to: CGPoint(x: rect.minX,
                                      y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX,
                                         y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX,
                                         y: rect.minY))
            }.stroke(lineWidth: 1)
        }
    }
    
    var cellBackground : some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.white)
            .opacity(0.65)
            .scaledToFit()
            .padding(.all, 3)
            .shadow(radius: 20)
    }
    
    var cornerView : some View {
        GeometryReader {geo in
            let textRect = geo.frame(in: .local)
            Text("X").font(.title).position(textRect.bottom)
            Text("O").font(.title).position(textRect.right)
            
        }.scaledToFit()
    }
    
    func cell(key1: GameStatsKey,
              key2: GameStatsKey) -> some View {
        VStack {
            Text("wins: \(wins(key1: key1, key2: key2))")
            Text("losses: \(losses(key1: key1, key2: key2))")
            Text("ties: \(ties(key1: key1, key2: key2))")
        }
    }
    
    func wins(key1: GameStatsKey, key2: GameStatsKey) -> Int {
        store.state[gameStatsFor: key1].wins[key2] ?? 0
    }
    
    func losses(key1: GameStatsKey, key2: GameStatsKey) -> Int {
            store.state[gameStatsFor: key1].losses[key2] ?? 0
    }
    
    func ties(key1: GameStatsKey, key2: GameStatsKey) -> Int {
            store.state[gameStatsFor: key1].ties[key2] ?? 0
    }
    
    var xKeys : [GameStatsKey] {
            RawPlayer.allCases.map {raw in
                GameStatsKey(player: .x,
                             rawPlayer: raw)
            }
    }
    
    var oKeys : [GameStatsKey] {
        RawPlayer.allCases.map {raw in
            GameStatsKey(player: .o,
                         rawPlayer: raw)
        }
    }
    
}

extension CGRect {
    
    var bottom : CGPoint {
        CGPoint(x: 0.5 * minX + 0.5 * maxX,
                y: 0.2 * minY + 0.8 * maxY)
    }
    
    var right : CGPoint {
        CGPoint(x: 0.2 * minX + 0.8 * maxX,
                y: 0.5 * minY + 0.5 * maxY)
    }
    
}

struct HallOfFamePreview : PreviewProvider {
    
    static var previews: some View {
        HallOfFame()
            .environmentObject(AppState.makeStore())
    }
    
}
