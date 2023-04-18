//
//  Home.swift
//  Task Manager
//
//  Created by Ogabek Matyakubov on 17/04/23.
//

import SwiftUI

struct Home: View {
    
    @StateObject var taskViewModel: TaskViewModel = .init()
    
    // MARK: -- Marched Geometry Namespace
    @Namespace var animation
    
    // MARK: - Fetching Task
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], animation: .easeInOut) var tasks: FetchedResults<Task>
    
    @Environment(\.self) var env
    
    var body: some View {
        ScrollView(. vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Here's update today")
                        .font(.title2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, -20)
                .padding(.bottom)
                
                CustomSegmentedBar()
                    .padding(.top, 5)
                
                TaskView()
                    .padding(.top, 5)
                
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            // MARK: -- Add Button
            Button {
                taskViewModel.editTask = nil
                taskViewModel.openEditTask.toggle()
            } label: {
                Label {
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in: Capsule())
            }
            // MARK: -- Linear Gradient Background
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background {
                LinearGradient(colors: [
                    .white.opacity(0.05),
                    .white.opacity(0.4),
                    .white.opacity(0.7),
                    .white
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $taskViewModel.openEditTask) {
            taskViewModel.resettingData()
        } content: {
            AddNewTask().environmentObject(taskViewModel)
        }
    }
    
    // MARK: - Task View
    @ViewBuilder
    func TaskView() -> some View {
        LazyVStack(spacing: 20) {
            DinamicFilteredView(currentTab: taskViewModel.currentTab) { (task: Task) in
                TaskRowView(task: task)
            }
        }
        
        .padding(.top, 20   )
    }
    
    // MARK: - Task Row View
    @ViewBuilder
    func TaskRowView(task: Task) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(task.type ?? "")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.3))
                    }
                
                Spacer()
                
                // MARK: - Edit Button Only for Non Completed Tasks
                Button {
                    taskViewModel.editTask = task
                    taskViewModel.openEditTask = true
                    taskViewModel.setUpTask()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.black)
                }
            }
            
            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical, 10)
            
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !task.isCompleted && taskViewModel.currentTab != "Failed" {
                    Button {
                        // MARK: - Updating Core Data
                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                    } label: {
                        Circle()
                            .strokeBorder(.black, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }

                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }
    }
    
    //MARK: - Custom Segmented Bar
    @ViewBuilder
    func CustomSegmentedBar() -> some View {
        let tabs = ["Today", "Coming", "Done", "Failed"]
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(taskViewModel.currentTab == tab ? .white : .black)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background {
                        if taskViewModel.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "Tab", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            taskViewModel.currentTab = tab
                        }
                    }
            }
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
