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
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Календарь")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
            
            // DatePicker с графическим стилем
            VStack {
                DatePicker(
                    "Выберите дату",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding()
            
            // Количество задач на выбранный день
            HStack {
                Text("Задачи")
                    .font(.headline)
                
                Spacer()
                
                if tasksForDay(selectedDate).count > 0 {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text("\(tasksForDay(selectedDate).count)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(.horizontal)
            
            // Список задач на выбранный день
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(tasks) { task in
                        if task.date == selectedDate {
                            TaskRowForCalendar(task: task)
                        }
                    }
                    
                    if tasksForDay(selectedDate).isEmpty {
                        VStack {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            
                            Text("Нет задач на этот день")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .background(Color(.systemBackground))
    }
    
    private func tasksForDay(_ date: Date) -> [TaskModel] {
        tasks.filter { Calendar.current.isDate($0.date!, inSameDayAs: date) }
            .sorted { $0.date! < $1.date! }
    }
}

struct TaskRowForCalendar: View {
    let task: TaskModel
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                .foregroundColor(task.isCompleted ? .green : .gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .strikethrough(task.isCompleted)
                
                if let category = task.category {
                    Text(category.name)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text(timeFormatter(task.date!))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    func timeFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: TaskModel.self, inMemory: true)
}

