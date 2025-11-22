//
//  AddCategoryViewToolbar.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 09.10.2025.
//

import SwiftUI

struct AddCategoryViewToolbar: ToolbarContent {
    @Environment(\.dismiss) var dismiss
    
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
//                add_new_task()
//                if (!showAlert){
//                    dismiss()
//                }
                
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
            }
        }
    }
}
