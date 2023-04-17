//
//  Task_ManagerApp.swift
//  Task Manager
//
//  Created by Ogabek Matyakubov on 17/04/23.
//

import SwiftUI

@main
struct Task_ManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
