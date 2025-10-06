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
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .blue)
                .onTapGesture {withAnimation {
                    task.isCompleted.toggle()
                } }
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.body)
                    .bold()
                Text(task.createdDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}


#Preview {
    TaskItemView(task: TaskModel(title: "Test", isCompleted: false, date: nil, category: nil, note: "Test more"))
}
