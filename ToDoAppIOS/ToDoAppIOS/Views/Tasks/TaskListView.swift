//
//  TaskListView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 06.10.2025.
//

import SwiftUI
import SwiftData

enum SortType: String, CaseIterable, Identifiable {
    case name = "По имени"
    case dueDate = "По дате"
    case createdDate = "По дате создания"
    
    var id: String { self.rawValue }
}

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskModel.name, order: .reverse) private var tasks: [TaskModel]
    
    @State private var selectedCategory: String = "Все"
    @State private var sortType: SortType = .name
    @State private var ascending: Bool = true
    @State private var selectedTask: TaskModel? = nil
    
    var categories: [String] {
        let raw = tasks.compactMap { $0.category?.name }
        return ["Все"] + Array(Set(raw)).sorted()
    }

    var filteredTasks: [TaskModel] {
        selectedCategory == "Все" ? tasks :
        tasks.filter { $0.category?.name == selectedCategory }
    }
    
    var sortedTasks: [TaskModel] {
            switch sortType {
            case .name:
                return filteredTasks.sorted { $0.name < $1.name }
            case .dueDate:
                return filteredTasks.sorted { $0.date ?? Date(timeIntervalSinceNow: .infinity) < $1.date ?? Date(timeIntervalSinceNow: .infinity)}
            case .createdDate:
                return filteredTasks.sorted { $0.createdDate > $1.createdDate }
            }
    }
    
    var activeTasks: [TaskModel] {sortedTasks.filter { !$0.isCompleted }}
    var completedTasks: [TaskModel] {sortedTasks.filter { $0.isCompleted }}
    
    var body: some View {
        VStack{
            HStack{
                Picker("Категория",selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { option in
                        Text(option)
                    }
                }
                .padding(.horizontal)
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Picker(selection: $sortType, label: HStack {
                    Image(systemName: "chevron.down")
                    Text("Сортировка")
                }) {
                    ForEach(SortType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .padding(.horizontal)
                .pickerStyle(.menu)
            }
            
            List{
                Section(header: Text("Активные задачи")) {
                    ForEach(activeTasks) { task in
                        NavigationLink(destination: EditTaskView(task: task)){
                            TaskItemView(task: task)
                        }
                        
                    }
                    .onDelete{ indexSet in deleteActiveTasks(at: indexSet)}
                }.listRowBackground(Color(.systemGray6).opacity(0.7))
                Section(header: Text("Выполненные задачи")) {
                    ForEach(completedTasks) { task in
                        NavigationLink(destination: EditTaskView(task: task)){
                            TaskItemView(task: task)
                        }
                    }
                    .onDelete { indexSet in deleteCompletedTasks(at: indexSet)}
                }.listRowBackground(Color(.systemGray6).opacity(0.7))
            }
            .scrollContentBackground(.hidden)
        }
    }
    
    func deleteActiveTasks(at offsets: IndexSet) {
        for index in offsets {
            let task = activeTasks[index]
            NotificationManager.shared.cancelReminder(for: task.id)
            modelContext.delete(task)
        }
    }

    // Удаление завершённых задач
    func deleteCompletedTasks(at offsets: IndexSet) {
        for index in offsets {
            let task = completedTasks[index]
            NotificationManager.shared.cancelReminder(for: task.id)
            modelContext.delete(task)
        }
    }
    
    
}

