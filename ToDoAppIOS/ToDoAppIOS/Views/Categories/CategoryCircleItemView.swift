//
//  CategoryCircleItemView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 02.10.2025.
//

import SwiftUI

struct CategoryCircleItemView: View {
    let category: CategoryModel
    let isSelected: Bool
    let onTap: () -> Void
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
    }
}

