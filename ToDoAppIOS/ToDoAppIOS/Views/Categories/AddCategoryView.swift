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
        VStack {
            TextField("Название категории", text: $categoryName)
            ColorPicker("Выберите цвет", selection: $selectedColor)
            Button(action: {
                let newCategory = CategoryModel(name: categoryName, color: selectedColor)
                onAddCategory(newCategory)
            }) {
                
                Text("Добавить категорию")
            }
        }
        
    }
    
    var onAddCategory: (CategoryModel) -> Void
}

