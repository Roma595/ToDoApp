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
    @State private var selectedCategory: String = "Все"
    
    var categories: [String] {
        let raw = tasks.compactMap { $0.category?.name }
        return ["Все"] + Array(Set(raw)).sorted()
    }

    var filteredTasks: [TaskModel] {
        selectedCategory == "Все" ? tasks :
        tasks.filter { $0.category?.name == selectedCategory }
    }
    
    var activeTasks: [TaskModel] {filteredTasks.filter { !$0.isCompleted }}
    var completedTasks: [TaskModel] {filteredTasks.filter { $0.isCompleted }}
    
    var body: some View {
        
        VStack{
            Picker("Категория",selection: $selectedCategory) {
                ForEach(categories, id: \.self) { option in
                    Text(option)
                }
            }
            .padding(.horizontal)
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
//            Picker("Категория", selection: $selectedCategory) {
//                ForEach(categories, id: \.self) { cat in
//                    Text(cat)
//                }
//            }
//            .pickerStyle(MenuPickerStyle())
//            .padding()
            List{
                Section(header: Text("Активные задачи")) {
                    ForEach(activeTasks) { task in
                        TaskItemView(task: task)
                    }
                    .onDelete{ indexSet in deleteActiveTasks(at: indexSet)}
                }
                            
                Section(header: Text("Выполненные задачи")) {
                    ForEach(completedTasks) { task in
                        TaskItemView(task: task)
                    }
                    .onDelete { indexSet in deleteCompletedTasks(at: indexSet)}
                }
            }
        }
    }
    
    func deleteActiveTasks(at offsets: IndexSet) {
        for index in offsets {
            let task = activeTasks[index]
            modelContext.delete(task)
        }
    }

    // Удаление завершённых задач
    func deleteCompletedTasks(at offsets: IndexSet) {
        for index in offsets {
            let task = completedTasks[index]
            modelContext.delete(task)
        }
    }
}

