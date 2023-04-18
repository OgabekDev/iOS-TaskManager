//
//  ContentView.swift
//  Task Manager
//
//  Created by Ogabek Matyakubov on 17/04/23.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Task Manager")
        }
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
