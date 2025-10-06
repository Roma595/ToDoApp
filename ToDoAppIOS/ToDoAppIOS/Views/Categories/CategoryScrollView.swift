//
//  CategoryScrollView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 18.09.2025.
//

import SwiftUI
import SwiftData

struct CategoryScrollView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CategoryModel.name) private var categories: [CategoryModel]
//    @State private var categories: [CategoryModel] = []
    @State private var showAddCategoryView: Bool = false
    @State private var selectedIndex: Int? = nil
    @State private var isSelectedCategory: Bool = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(Array(categories.enumerated().reversed()), id: \.element.id){
                    (index, category) in
                    VStack{
                        //MARK: - CategoryCircleItemView
                        CategoryCircleItemView(
                            category: category,
                            isSelected: selectedIndex == index,
                            onTap: {
                                if (selectedIndex == index){
                                    selectedIndex = nil
                                }
                                else{
                                    selectedIndex = index
                                }
                            }
                        )
                        //MARK: - Text
                        Text(category.name)
                            .font(.caption)
                    }
                }
                
                //MARK: - Button add new category
                Button(action:{
                    showAddCategoryView = true
                }){
                    VStack{
                        Circle()
                            .frame(width: 70, height: 70)
                            .foregroundStyle(.gray)
                            .overlay(
                                Image(systemName: "plus")
                                    .foregroundStyle(.white)
                            )
                        
                        Text("Новая").font(.caption)
                    }
                        
                        
                }
                
            }
            .padding(.horizontal)
            
        }
        .sheet(isPresented: $showAddCategoryView){
            AddCategoryView(onAddCategory: {
                newCategory in
                modelContext.insert(newCategory)
                showAddCategoryView = false
                try_save_context()
            })
            
        }
        .frame(height: 120)
        
    }
    
    func try_save_context(){
        do {
            try modelContext.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
}

