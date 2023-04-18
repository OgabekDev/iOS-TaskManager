//
//  TaskViewModel.swift
//  Task Manager
//
//  Created by Ogabek Matyakubov on 17/04/23.
//

import Foundation
import CoreData
import SwiftUI

class TaskViewModel: ObservableObject {
    
    @Published var currentTab: String = "Today"
    
    // MARK: - New Task Properties
    @Published var openEditTask = false
    @Published var taskTitle = ""
    @Published var taskColor = "Yellow"
    @Published var taskDeadline = Date()
    @Published var taskType = "Basic"
    @Published var showDatePicker: Bool = false
    
    // MARK: - Editing Existing Task
    @Published var editTask: Task?
    
    // MARK: - Adding New Task to Core Data
    func addNewTask(context: NSManagedObjectContext) -> Bool {
        // MARK: - Updating Existing Data in Core Data
        var task: Task!
        if let editTask = editTask {
            task = editTask
        } else {
            task = Task(context: context)
        }
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    // MARK: - Resetting Data
    func resettingData() {
        taskTitle = ""
        taskColor = "Yellow"
        taskDeadline = Date()
        taskType = "Basic"
    }
    
    // MARK: - If Edit Task is available then Setting Existing Task
    func setUpTask() {
        if let editTask = editTask {
            taskTitle = editTask.title ?? ""
            taskColor = editTask.color ?? "Yellow"
            taskDeadline = editTask.deadline ?? Date()
            taskType = editTask.type ?? "Basic"
        }
    }
    
}
