//
//  CategoryScrollView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 18.09.2025.
//

import SwiftUI

struct CategoryScrollView: View {
    
    let categories: [CategoryModel] = [
            CategoryModel(name: "Работа", color: .red),
            CategoryModel(name: "Дом", color: .blue),
            CategoryModel(name: "Учёба", color: .green),
            CategoryModel(name: "Спорт", color: .orange),
            CategoryModel(name: "Хобби", color: .purple)
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(categories) { category in
                    CategoryCircleView(category: category)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 120)
    }
}

#Preview {
    CategoryScrollView()
}
