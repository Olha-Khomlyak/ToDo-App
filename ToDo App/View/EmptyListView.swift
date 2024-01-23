//
//  EmptyListView.swift
//  ToDo App
//
//  Created by A. Faruk Acar on 19.01.2024.
//

import SwiftUI

struct EmptyListView: View {
    
    
    // MARK:  PROPERTIES
    @State private var isAnimated:Bool = false
    
    
    // MARK:  THEME
    
    @ObservedObject var theme = ThemeSettings.shared
    let themes: [Theme] = themeData
    
    var body: some View {
        ZStack {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20) {
                Image("\(images.randomElement() ?? "illustration-no1")")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
                Text("\(tips.randomElement() ?? "Use your time wisely.")")
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
            }
            .padding(.horizontal)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : -50)
            .animation(.easeInOut(duration: 1.5), value: 1)
            .onAppear(perform: {
                self.isAnimated.toggle()
            })
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("ColorBase"))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    EmptyListView()
}
