//
//  ToDo_AppApp.swift
//  ToDo App
//
//  Created by A. Faruk Acar on 26.12.2023.
//

import SwiftUI

@main
struct ToDo_AppApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var alternateIcons = AlternateIcons()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(alternateIcons)
        }
    }
}


