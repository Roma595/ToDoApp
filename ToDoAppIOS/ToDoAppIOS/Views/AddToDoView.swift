//
//  AddToDoView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 17.09.2025.
//

import SwiftUI

struct AddToDoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Новая задача")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Введите название задачи")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Отмена") {
                            dismiss()
                        }
                    }
                }
                
            }
            
            
        }
    }
}

#Preview {
    AddToDoView()
}
