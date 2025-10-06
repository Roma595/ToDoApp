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
    
    @Binding var activeSheet: AddToDoSheet?
    @State private var selectedIndex: Int? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(Array(categories.enumerated().reversed()), id: \.element.id){ (index, category) in
                    VStack{
                        CategoryCircleItemView(
                            category: category,
                            isSelected: selectedIndex == index,
                            onTap: {tap_on_item(index: index)}
                        )
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
        }
        else{
            selectedIndex = index
        }
    }
}

