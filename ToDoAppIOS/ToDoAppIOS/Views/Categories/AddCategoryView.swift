//
//  AddCategoryView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 01.10.2025.
//

import SwiftUI

struct AddCategoryView: View {
    @State private var categoryName:String = ""
    @State private var selectedColor:Color = .black
    
    var body: some View {
        VStack(spacing: 20){
            TextField("Название категории", text: $categoryName)
                .font(.title2)
                .padding(.horizontal)
            
            ColorPicker("Цвет", selection: $selectedColor)
                .font(.title2)
                .padding(.horizontal)
            
            Text("Иконка")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Circle()
                .fill(selectedColor)
                .frame(width: 100, height: 100)
                
                
            
            Button(action: {
                let newCategory = CategoryModel(name: categoryName, color: selectedColor)
                onAddCategory(newCategory)
            }) {
                Rectangle()
                    .fill(.white)
                    .frame(width: 200, height: 50)
                    .cornerRadius(25)
                    .overlay(
                        Text("Добавить категорию")
                            .font(.headline)
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 2)
                
            }
        }
        
    }
    
    var onAddCategory: (CategoryModel) -> Void
}

#Preview {
    AddCategoryView(onAddCategory: { _ in })
}
