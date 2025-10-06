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
                HStack{
                    Button(action: {
                        selectedDate = nil;
                        dismiss()
                    }){
                        Text("Отмена")
                    }
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Button(action: {
                        dismiss()
                    }){
                        Text("Добавить")
                    }
                    .padding(.trailing, 15)
                    
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                    
                }
                .padding(.top, 4)
                
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
            }

        }
    }
    
}

