//
//  AddNotificationViewToolbar.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 09.10.2025.
//

import SwiftUI

struct AddNotificationViewToolbar: ToolbarContent {
    @Environment(\.dismiss) var dismiss
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
        }
    }
}
