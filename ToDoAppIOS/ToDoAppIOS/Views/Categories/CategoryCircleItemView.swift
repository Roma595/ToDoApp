//
//  CategoryCircleItemView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 02.10.2025.
//

import SwiftUI

struct CategoryCircleItemView: View {
    @Environment(\.dismiss) var dismiss
    let category: CategoryModel
    let isSelected: Bool
    let onTap: () -> Void
    let onDelete:() -> Void
    
    @State private var activeSheet: CategorySheet?
    
    @State private var showMenu = false
    @State private var showDeleteAlert = false
    var body: some View {
        Circle()
            .fill(category.color)
            .frame(width: 70, height: 70)
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 4)
            )
            .scaleEffect(isSelected ? 1.1 : 1)
            .animation(.spring(), value: isSelected)
            .onTapGesture {
                onTap()
            }
            .onLongPressGesture {
                showMenu = true
            }
            .confirmationDialog("Действия с категорией", isPresented: $showMenu) {
                Button("Редактировать") {activeSheet = .edit}
                Button("Удалить", role: .destructive) { showDeleteAlert = true}
                Button("Отмена", role: .cancel) { }
            }
            .sheet(item: $activeSheet) {sheet in
                switch sheet {
                case .edit:
                    EditCategoryView(category: category)
                        .presentationDetents([.height(300)])
                        .interactiveDismissDisabled(true)
                case .delete:
                    EditCategoryView(category: category)
                        .presentationDetents([.height(300)])
                        .interactiveDismissDisabled(true)
                }
            }
            .alert("Все связанные задачи с этой категорией будут удалены", isPresented: $showDeleteAlert) {
                Button("Ок", role: .destructive) {onDelete()}
                Button("Отмена", role: .cancel) { }
            } message: {
                Text("Вы уверены?")
            }
    }

}

