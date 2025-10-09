//
//  AddCategoryView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 01.10.2025.
//

import SwiftUI
import SwiftData

struct AddCategoryView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CategoryModel.name) private var categories: [CategoryModel]
    
    @State private var categoryName:String = ""
    @State private var selectedColor:Color = .black
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                TextField("Название категории", text: $categoryName)
                    .font(.title2)
                    .padding(.horizontal)
                
                ColorPicker("Цвет", selection: $selectedColor)
                    .font(.title2)
                    .padding(.horizontal)
                
                Button(action: {
                    let newCategory = CategoryModel(name: categoryName, color: selectedColor)
                    modelContext.insert(newCategory)
                    try_save_context()
                    dismiss()
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
            .toolbar{
                AddCategoryViewToolbar()
            }
        }
        
        
    }
    func try_save_context(){
        do {
            try modelContext.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
    
}

#Preview {
    AddCategoryView()
}
