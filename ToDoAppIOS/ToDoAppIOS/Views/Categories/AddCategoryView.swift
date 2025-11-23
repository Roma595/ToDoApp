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

//                        .alert("Не все поля заполнены", isPresented: $showAlert) {
//                    Button("Ок", role: .cancel) { }
//                } message: {
//                    Text("Введите название категории")
//                }
                
            }
            .toolbar{
                AddCategoryViewToolbar(add_new_category: add_new_category)
            }
        }
        
        
    }
    
    func add_new_category(){
//        if categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            showAlert = true
//            return
//        }
        let newCategory = CategoryModel(name: categoryName, color: selectedColor)
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
