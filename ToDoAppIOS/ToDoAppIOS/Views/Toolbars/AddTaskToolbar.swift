//
//  AddTaskToolbar.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 22.11.2025.
//

import SwiftUI

struct AddTaskToolbar: ToolbarContent {
    @Environment(\.dismiss) var dismiss
    @Binding var showAlert: Bool
    let add_new_task: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                add_new_task()
                if (!showAlert){
                    dismiss()
                }
                
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
            }
            .alert("Не все поля заполнены", isPresented: $showAlert) {
                Button("Ок", role: .cancel) { }
            } message: {
                Text("Введите название задачи")
            }
            
        }
    }
}
