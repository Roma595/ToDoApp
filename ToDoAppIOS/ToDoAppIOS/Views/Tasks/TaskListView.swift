//
//  TaskListView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 06.10.2025.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskModel.createdDate, order: .reverse) private var tasks: [TaskModel]
    
    var activeTasks: [TaskModel] {tasks.filter { !$0.isCompleted }}
    var completedTasks: [TaskModel] {tasks.filter { $0.isCompleted }}
    
    var body: some View {
        List{
            Section(header: Text("Активные задачи")) {
                ForEach(activeTasks) { task in
                    TaskItemView(task: task)
                }
            }
                        
            Section(header: Text("Выполненные задачи")) {
                ForEach(completedTasks) { task in
                    TaskItemView(task: task)
                }
            }
        }
    }
}

