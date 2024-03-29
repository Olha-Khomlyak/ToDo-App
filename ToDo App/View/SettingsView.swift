//
//  SettingsView.swift
//  ToDo App
//
//  Created by A. Faruk Acar on 19.01.2024.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK:  PROPERTIES
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iconSettings: AlternateIcons
    @State private var isThemeChanged: Bool = false
    // MARK:  THEME
    
    @ObservedObject var theme = ThemeSettings.shared
    let themes: [Theme] = themeData
    
    // MARK:  BODY
    var body: some View {
        NavigationView {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,spacing: 0){
                // MARK:   FORM
                Form{
                    
                    // MARK:  SECTION 1
                    
                    Section(header: Text("Choose the app icon")){
                        Picker(selection:$iconSettings.currentIndex, label:
                                
                                HStack {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .strokeBorder(Color.primary, lineWidth:2)
                                
                                Image(systemName: "paintbrush")
                                    .font(.system(size: 28,weight:.regular, design: .default))
                                    .foregroundStyle(Color.primary)
                            }
                            .frame(width:44, height:44)
                            
                            Text("App Icons".uppercased())
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                               
                               
                        ){
                            ForEach(iconSettings.iconNames.indices, id: \.self) { index in
                                HStack {
                                    Image(uiImage: UIImage(named: self.iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(8)
                                    
                                    Spacer().frame(width: 8)
                                    
                                    Text(self.iconSettings.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                } //: HSTACK
                                .padding(3)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .onReceive([self.iconSettings.currentIndex].publisher.first()) { (value) in
                            let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                            if index != value {
                                UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]) { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("Success! You have changed the app icon.")
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical,3)
                    
                    // MARK:  SECTION 2
                    
                    Section(header:
                                
                                HStack {
                        Text("Choose the app theme")
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundStyle(themes[self.theme.themeSettings].themeColor)
                    }
                    
                    ) {
                        List{
                            ForEach(themes, id: \.id) { item in
                                Button(action: {
                                    self.theme.themeSettings = item.id
                                    UserDefaults.standard.set(self.theme.themeSettings,forKey:"Theme")
                                    self.isThemeChanged.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundStyle(item.themeColor)
                                        
                                        Text(item.themeName)
                                    }
                                }
                                .accentColor(Color.primary)
                            }
                        }
                    }
                    .padding(.vertical,3)
//                    .alert(isPresented: $isThemeChanged){
//                        Alert(title: Text("SUCCESS"), message: Text("App has changed to the \(themes[self.theme.themeSettings].themeName). Now close and restart it"), dismissButton: .default(Text("OK")))
//                    }

                    // MARK:  SECTION 3
                    
                    
                    Section(header: Text("Follow us on social meadia")){
                        FormRowLinkView(icon: "globe", color: .pink, text: "Website", link: "https://swiftuimasterclass.com")
                        FormRowLinkView(icon: "link", color: Color.blue, text: "Twitter", link: "https://twitter.com/robertpetras")
                        FormRowLinkView(icon: "play.rectangle", color: Color.green, text: "Courses", link: "https://www.udemy.com/user/robert-petras")
                    }
                    .padding(.vertical,3)
                    
                    
                    // MARK:  SECTION 4
                    
                    Section(header:Text("About the application")){
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone,iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText:"Funduk")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Robert Petras")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    }
                    .padding(.vertical,3)
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                // MARK:  FOOTER
                Text("Copyright © All rights reserved. \nBetter Apps ♡ Less Code ")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top,6)
                    .padding(.bottom,8)
                    .foregroundColor(.secondary)
                
                
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }
                                           , label: {
                Image(systemName: "xmark")
            }))
            .background(Color("ColorBackground"))
        }
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    SettingsView().environmentObject(AlternateIcons())
}

