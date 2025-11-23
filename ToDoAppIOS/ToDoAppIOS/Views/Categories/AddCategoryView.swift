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
    
    @State private var showEmptyNameAlert = false
    @State private var showDuplicateNameAlert = false
    
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
                AddCategoryViewToolbar(add_new_category: add_new_category, showEmptyNameAlert: $showEmptyNameAlert, showDuplicateNameAlert: $showDuplicateNameAlert)
            }
            
        }
        
        
    }
    
    func add_new_category(){
        let trimmedName = categoryName.trimmingCharacters(in: .whitespaces)
        
        if trimmedName.isEmpty {
            showEmptyNameAlert = true
            return
        }
        
        if categories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) {
            showDuplicateNameAlert = true
            return
        }
        
        let newCategory = CategoryModel(name: trimmedName, color: selectedColor)
        modelContext.insert(newCategory)
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

#Preview {
    AddCategoryView()
}
