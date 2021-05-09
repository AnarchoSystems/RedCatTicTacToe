//
//  CellButtonView.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 09.05.21.
//

import SwiftUI


struct CellButton : View {
    
    let label : Player?
    let action: () -> Void
    
    var body: some View {
        GeometryReader {geo in
            let size = min(geo.size.width, geo.size.height)
            Button(label.map(\.rawValue) ?? "",
                   action: action)
                .buttonStyle(CellButtonStyle(size: size,
                                             center: geo.frame(in: .local).center))
        }
    }
    
}


struct CellButtonStyle : ButtonStyle {
    
    let size : CGFloat
    let center : CGPoint
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(configuration.isPressed ? .accentColor : Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6548133902)))
                .padding(4)
                .shadow(radius: 5)
            configuration.label
                .position(center)
        }
        .font(.system(size: 0.7 * size,
                      weight: .heavy,
                      design: .default))
    }
    
}


struct CellPreview : PreviewProvider {
    static var previews: some View {
        CellButton(label: .o){}
    }
}
