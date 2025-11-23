//
//  TaskItemView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 02.10.2025.
//

import SwiftUI

struct TaskItemView: View {
    let task: TaskModel
    @State var isEditing: Bool = false
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .blue)
                .onTapGesture {withAnimation {
                    task.isCompleted.toggle()
                } }
            HStack{
                VStack(alignment: .leading) {
                    Text(task.name)
                        .font(.body)
                        .bold()
                    
                    if task.date != nil {
                        Text(dateFormatter.string(from: task.date!) )
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            .contentShape(Rectangle())
        }

        .padding(.vertical, 6)
    }
    
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateStyle = .long
            return formatter
    }
}


#Preview {
    TaskItemView(task: TaskModel(name: "Test", isCompleted: false, date: nil, category: nil, note: "Test more"))
}
