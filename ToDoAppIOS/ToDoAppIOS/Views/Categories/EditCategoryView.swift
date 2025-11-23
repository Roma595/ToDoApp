//
//  EditCategoryView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 23.11.2025.
//

import SwiftUI
import SwiftData

struct EditCategoryView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CategoryModel.name) private var categories: [CategoryModel]

    let category:CategoryModel
    @State private var categoryName:String
    @State private var selectedColor:Color
    
    init(category: CategoryModel){
        self.category = category
        categoryName = category.name
        selectedColor = category.color
    }
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                TextField("Название категории", text: $categoryName)
                    .font(.title2)
                    .padding(.horizontal)
                ColorPicker("Цвет", selection: $selectedColor)
                    .font(.title2)
                    .padding(.horizontal)
            }
            .toolbar{
                EditCategoryViewToolbar(editCategory:
                    editCategory)
            }
        }
    }
    
    func editCategory(){
        category.name = categoryName
        category.colorHex = selectedColor.toHex()
        try_save_context()
    }
    
    func try_save_context(){
        do {
            try modelContext.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
}
