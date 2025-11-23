//
//  NotificationDatePickerView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 23.11.2025.
//

import SwiftUI

struct NotificationDatePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDateTime: Date?
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                DatePicker(
                    "Дата и время",
                    selection: Binding(
                        get: { selectedDateTime ?? Date() },
                        set: { selectedDateTime = $0 }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale(identifier: "ru_RU"))
                .padding()
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена")
                    {
                        selectedDateTime = nil
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        dismiss()
                    } label: {
                        Text("Добавить")
                    }
                }
            }
        }
    }
}

#Preview {
    NotificationDatePickerView(
        selectedDateTime: .constant(Date().addingTimeInterval(3600))
    )
}

