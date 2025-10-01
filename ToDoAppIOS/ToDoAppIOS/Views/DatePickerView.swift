//
//  DatePickerView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 18.09.2025.
//

import SwiftUI

struct DatePickerSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()
            Button("Установить") {
                dismiss()
            }
            .padding()
        }
        .presentationDetents([.medium]) // iOS 16+ для высоты popup
    }
    
}

#Preview {
    DatePickerSheet(selectedDate: .constant(Date())).environment(\.locale, Locale(identifier: "ru_RU"))
}
