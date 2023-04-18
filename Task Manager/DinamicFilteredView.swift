//
//  DinamicFilteredView.swift
//  Task Manager
//
//  Created by Ogabek Matyakubov on 18/04/23.
//

import SwiftUI
import CoreData

struct DinamicFilteredView<Content: View, T>: View where T: NSManagedObject {
    
    // MARK: - Core Data Request
    @FetchRequest var request: FetchedResults<T>
    
    let content: (T) -> Content
    
    // MARK: - Building Custom ForEach which will give CoreData Object to build View
    init(currentTab: String, @ViewBuilder content: @escaping (T) -> Content) {
        
        // MARK: Predicate to Filter current date tasks
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        if currentTab == "Today" {
            let today = Date()
            let tomarrow = calendar.date(byAdding: .day, value: 1, to: today)
            
            // Filter key
            let filterKey = "deadline"
            
            // This will fetch tasks between today and tomarrow which is 24 Hours
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) <= %@ AND isCompleted == %i", argumentArray: [today, tomarrow ?? today, 0])
            
        } else if currentTab == "Coming" {
            let start = Date()
            let finish = Date.distantFuture
            
            // Filter key
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) <= %@ AND isCompleted == %i", argumentArray: [start, finish, 0])
        } else if currentTab == "Done" {
            let start = Date.distantPast
            let finish = Date.distantFuture
            
            // Filter key
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) <= %@ AND isCompleted == %i", argumentArray: [start, finish, 1])
        } else {
            let start = Date.distantPast
            let finish = Date()
            
            // Filter key
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) <= %@ AND isCompleted == %i", argumentArray: [start, finish, 0])
        }
        
        // Initilizing Request with NSPredicate
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("No Tasks found!!!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.self) { object in
                    self.content(object)
                }
            }
        }
    }
}
