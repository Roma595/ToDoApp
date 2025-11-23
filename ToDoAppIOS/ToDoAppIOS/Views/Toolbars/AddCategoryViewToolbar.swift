//
//  AddCategoryViewToolbar.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 09.10.2025.
//

import SwiftUI

struct AddCategoryViewToolbar: ToolbarContent {
    @Environment(\.dismiss) var dismiss
    
    let add_new_category: () -> Void
    @Binding var showEmptyNameAlert: Bool
    @Binding var showDuplicateNameAlert: Bool
//    let showAlert: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                add_new_category()
                if (!showEmptyNameAlert && !showDuplicateNameAlert) {
                    dismiss()
                }
                
                
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
            }
            .alert("Введите название категории", isPresented: $showEmptyNameAlert) {
                Button("Ок", role: .cancel) { }
            } message: {
                Text("Название не должно быть пустым")
            }
            .alert("Категория уже существует", isPresented: $showDuplicateNameAlert) {
                Button("Ок", role: .cancel) { }
            } message: {
                Text("Категория с таким названием уже создана")
            }
            
        }
    }
}
