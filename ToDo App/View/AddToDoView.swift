//
//  AddToDoView.swift
//  ToDo App
//
//  Created by A. Faruk Acar on 26.12.2023.
//

import SwiftUI

struct AddToDoView: View {
    
    // MARK:  PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext


    @State private var name:String = ""
    @State private var priority:String = "Normal"
    
    let priorities = ["High", "Normal", "Low"]
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""

    // MARK:  THEME
    @ObservedObject var theme = ThemeSettings.shared
    let themes: [Theme] = themeData

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment:.leading, spacing: 20) {
                    TextField("ToDo", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24,weight: .bold, design: .default))
                    Picker("Priority", selection: $priority){
                        ForEach(priorities,id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Button(action: {
                        if self.name != "" {
                            let todo = TodoData(context: self.managedObjectContext)
                            todo.name = self.name
                            todo.priority = self.priority
                            
                            do {
                                try self.managedObjectContext.save()
                                print(todo.priority ?? "", todo.name ?? "")
                            } catch {
                                print(error)
                            }
                        } else {
                            self.errorShowing = true
                            self.errorTitle = "Invalid name"
                            self.errorMessage = "Make sure to enter something for\nthe new todo item."
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                           , label: {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(themes[self.theme.themeSettings].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                    })
                }
                .padding(.horizontal)
                .padding(.vertical,30)
                Spacer()
            }
            .navigationBarTitle("New Todo", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            }))
            .alert(isPresented: $errorShowing){
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        } //: NAVIGATION
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

#Preview {
    AddToDoView()
}
