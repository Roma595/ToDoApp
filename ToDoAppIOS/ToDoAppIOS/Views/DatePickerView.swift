//
//  DatePickerView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 18.09.2025.
//

import SwiftUI

struct DatePickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date?
    
    var body: some View {
        NavigationStack{
            VStack{
                DatePicker(
                    "",
                    selection: Binding(
                        get: { selectedDate ?? Date() },
                        set: { selectedDate = $0 }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale(identifier: "ru_RU"))
                .padding()
                
                Spacer()
                
            }
            .toolbar{
                DataPickerViewToolbar(selectedDate: $selectedDate)
            }

        }
    }
    
}

