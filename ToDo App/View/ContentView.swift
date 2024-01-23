//
//  ContentView.swift
//  ToDo App
//
//  Created by A. Faruk Acar on 26.12.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    // MARK:  PROPERTIES
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: TodoData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TodoData.name, ascending: true)]) var todos: FetchedResults<TodoData>
    
    @EnvironmentObject var iconSettings: AlternateIcons
    
    @State private var showingAddTodoView: Bool =  false
    @State private var animatingButton: Bool = false
    @State private var showingSettingsView: Bool = false
    
    // MARK:  THEME
    @ObservedObject var theme = ThemeSettings.shared
    let themes: [Theme] = themeData
    
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(self.todos, id: \.self) { todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(todo.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundStyle(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth:0.75))
                        }
                        .padding(.vertical,10)
                    }
                    .onDelete(perform: deleteTodo)
                    
                }
                .navigationBarTitle("Todo", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton().accentColor(themes[self.theme.themeSettings].themeColor),
                    trailing:
                                        Button(action: {
                    //Show add to do view
                    self.showingSettingsView.toggle()
                }, label: {
                    Image(systemName: "paintbrush")
                        .imageScale(.large)
                        .foregroundColor(themes[self.theme.themeSettings].themeColor)
                }))
                .sheet(isPresented: $showingSettingsView, content: {
                    SettingsView().environmentObject(self.iconSettings)
            })
                if todos.count == 0 {
                    EmptyListView()
                }
            }
            .sheet(isPresented: $showingAddTodoView, content: {
                AddToDoView().environment(\.managedObjectContext, self.managedObjectContext)
        })
            .overlay(
                ZStack {
                    Group{
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.2 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 68,height: 68,alignment: .center)
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.15 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 88,height: 88,alignment: .center)
                    }
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animatingButton)
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                })
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                    .onAppear(perform: {
                        self.animatingButton.toggle()
                    })
                }
                    .padding(.bottom,15)
                    .padding(.trailing, 15)
                    
                , alignment: .bottomTrailing
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
    
    // MARK:  FUNCTIONS
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            do {
                try managedObjectContext.save()
            } catch {
                print (error)
            }
        }
    }
    
    private func colorize(priority: String) -> Color{
        switch(priority) {
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
        }
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

