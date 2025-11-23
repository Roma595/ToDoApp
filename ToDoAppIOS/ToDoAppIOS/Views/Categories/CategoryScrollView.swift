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
    @Query(sort: \TaskModel.name) private var tasks: [TaskModel]
    
    @Binding var activeSheet: AddToDoSheet?
    @Binding var selectedCategory: CategoryModel?
    @State var selectedIndex: Int?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(Array(categories.enumerated().reversed()), id: \.element.id){ (index, category) in
                    VStack{
                        CategoryCircleItemView(
                            category: category,
                            isSelected: selectedCategory?.name == category.name,
                            onTap: {tap_on_item(index: index)},
                            onDelete: {delete_item(index: index)}
                        )
                        .padding(.vertical, 6)
                        Text(category.name)
                            .font(.caption)
                    }
                }
                
                Button(action:{ activeSheet = .category }){
                    VStack{
                        Circle()
                            .frame(width: 70, height: 70)
                            .foregroundStyle(.gray)
                            .overlay(
                                Image(systemName: "plus")
                                    .foregroundStyle(.white)
                            )
                            .padding(.vertical, 6)
                        Text("Новая").font(.caption)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    func try_save_context(){
        do {
            try modelContext.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
    
    func tap_on_item(index: Int){
        if (selectedIndex == index){
            selectedIndex = nil
            selectedCategory = nil
        }
        else{
            selectedIndex = index
            let reversedCategories = Array(categories.enumerated())
            selectedCategory = reversedCategories[index].element
        }
    }
    
    func delete_item(index: Int){
        selectedCategory = Array(categories.enumerated())[index].element
        let relatedTasks = tasks.filter { $0.category == selectedCategory }
        
        for task in relatedTasks {
            modelContext.delete(task)
        }
        
        modelContext.delete(selectedCategory!)
        try_save_context()
    }

}

