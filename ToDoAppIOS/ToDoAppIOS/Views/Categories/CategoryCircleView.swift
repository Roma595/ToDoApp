//
//  CategoryCircleView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 18.09.2025.
//

import SwiftUI

struct CategoryCircleView: View {
    let category: CategoryModel
    @State var imageName: String = "folder"
    var body: some View {
        VStack{
            Circle()
                .fill(category.color)
                .frame(width: 70, height: 70)
                .overlay(
                    Image(systemName: imageName)
                        .foregroundStyle(.white)
                )
            Text(category.name)
                .font(.caption)
        }
    }
}

#Preview {
    CategoryCircleView(category: CategoryModel(name: "test", color: .blue))
}


