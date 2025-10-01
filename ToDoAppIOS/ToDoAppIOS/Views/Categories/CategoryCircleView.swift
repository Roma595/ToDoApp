//
//  CategoryCircleView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 18.09.2025.
//

import SwiftUI

struct CategoryCircleView: View {
    let category: CategoryModel
    var body: some View {
        VStack{
            Circle()
                .fill(category.color)
                .frame(width: 70, height: 70)
                .overlay(
                    Text(String(category.name.prefix(1)))
                        .font(.title)
                        .foregroundColor(.white)
                )
            Text(category.name)
                .font(.caption)
        }
    }
}

#Preview {
    CategoryCircleView(category: CategoryModel(name: "test", color: .blue))
}


