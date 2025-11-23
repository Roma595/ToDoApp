//
//  EditCategoryViewToolbar.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 23.11.2025.
//

import SwiftUI

struct EditCategoryViewToolbar: ToolbarContent {
    @Environment(\.dismiss) var dismiss
    let editCategory: () -> Void
    
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
                editCategory()
                dismiss()
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
            }
        }
    }
}
