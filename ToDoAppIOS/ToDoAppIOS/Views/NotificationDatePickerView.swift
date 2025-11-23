//
//  NotificationDatePickerView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 23.11.2025.
//

import SwiftUI

struct NotificationDatePickerView: View {
    @Binding var isPresented: Bool
    @Binding var selectedDateTime: Date
    let onConfirm: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Выберите дату и время напоминания")
                    .font(.title2)
                    .padding()
                
                DatePicker(
                    "Дата и время",
                    selection: $selectedDateTime,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button("Отмена") {
                        isPresented = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                    
                    Button("Установить") {
                        onConfirm()
                        isPresented = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") { isPresented = false }
                }
            }
        }
    }
}

#Preview {
    NotificationDatePickerView(
        isPresented: .constant(true),
        selectedDateTime: .constant(Date().addingTimeInterval(3600)),
        onConfirm: {
            print("Напоминание установлено")
        }
    )
}

