//
//  MainMenu.swift
//  RedCatTicTacToe
//
//  Created by Markus Pfeifer on 07.05.21.
//

import SwiftUI
import RedCat


struct MainMenu : View {
    
    @EnvironmentObject var store : CombineStore<AppState.AppReducer>
    
    var body: some View {
        
        VStack {
            
            Button("Start Game"){
                store.send(Actions.SetUpGame())
            }
            Button("Hall of Fame"){
                store.send(Actions.GoToHallOfFame())
            }
            Button("Leave"){
                exit(EXIT_SUCCESS)
            }
            
        }
        .buttonStyle(MyMenuButtonStyle(width: 130,
                                       height: 40))
        .frame(width: 200,
               height: 300)
        .padding()
        .background(menuBackground)
        .border(Color.black, width: 2)
        
    }
    
    var menuBackground : some View {
        Color(#colorLiteral(red: 0.8766865078, green: 0.8604659674, blue: 0.897789552, alpha: 1)).opacity(0.8)
    }
    
}


struct MyMenuButtonStyle : ButtonStyle {
    
    let width: CGFloat
    let height : CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .shadow(radius: 2)
                .foregroundColor(!configuration.isPressed ?
                                    .init(NSColor.controlColor) :
                                    .accentColor)
                
                .frame(width: width, height: height)
        configuration.label
            .frame(width: width, height: height)
        }
    }
    
}


struct MainMenuPreview : PreviewProvider {
    
    static var previews: some View {
        MainMenu().environmentObject(AppState.makeStore())
    }
    
}
