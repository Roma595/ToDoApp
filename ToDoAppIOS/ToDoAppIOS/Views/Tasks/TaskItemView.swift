//
//  TaskItemView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 02.10.2025.
//

import SwiftUI

struct TaskItemView: View {
    let task: TaskModel

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Иконка или статус задачи
            Image(systemName: "checkmark.circle")
                .foregroundStyle(task.isCompleted ?  .green: .gray)
                .onTapGesture {
                    task.isCompleted.toggle()
                }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .strikethrough(task.isCompleted, color: .black)
            }
            
            Spacer()
        }
        .padding(.vertical, 15)
        .padding(.horizontal)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}


#Preview {
    TaskItemView(task: TaskModel(title: "Test", isCompleted: false, date: nil, category: nil, note: "Test more"))
}
