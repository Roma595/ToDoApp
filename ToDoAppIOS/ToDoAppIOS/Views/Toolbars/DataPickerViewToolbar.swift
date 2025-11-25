//
//  DataPickerViewToolbar.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 23.11.2025.
//

import SwiftUI

struct DataPickerViewToolbar: ToolbarContent {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date?
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading){
            Button {
                selectedDate = nil;
                dismiss()
            } label: {
                Text("Отмена")
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
