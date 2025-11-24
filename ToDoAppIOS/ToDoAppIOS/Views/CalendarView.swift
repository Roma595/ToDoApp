//
//  CalendarView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 17.09.2025.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskModel.id) private var tasks: [TaskModel]
    
    @State private var selectedDate = Date()
    
    var filteredTasks: [TaskModel] {
        tasks.filter { task in
            Calendar.current.isDate(task.date!, inSameDayAs: selectedDate) && !task.isCompleted}
                .sorted { $0.date! < $1.date! }
    }
    
    var body: some View {
        NavigationStack {
                // MARK: - Calendar
            DatePicker(
                "Выберите дату",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .navigationTitle(Text("Календарь"))
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.locale, Locale(identifier: "ru_RU"))
            .datePickerStyle(.graphical)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding()
            
            // MARK: - Количество задач на выбранный день
            HStack {
                Text("Задачи")
                    .font(.headline)
                
                Spacer()
                
                if filteredTasks.count > 0 {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text("\(filteredTasks.count)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            // MARK: - Список задач
            if filteredTasks.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("Нет задач на этот день")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(filteredTasks) { task in
                        NavigationLink(destination: EditTaskView(task: task)){
                            TaskItemView(task: task)
                        }
                    }
                }
                .listStyle(.plain)
            }
                
            
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: TaskModel.self, inMemory: true)
}

