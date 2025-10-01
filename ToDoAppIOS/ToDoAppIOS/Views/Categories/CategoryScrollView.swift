//
//  CategoryScrollView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 18.09.2025.
//

import SwiftUI

struct CategoryScrollView: View {
    
    @State private var categories: [CategoryModel] = []
    @State private var showAddCategoryView: Bool = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(categories.reversed()) { category in
                    CategoryCircleView(category: category)
                }
                
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
                        
                        Text("Новая").font(.caption).foregroundStyle(.black)
                    }
                        
                        
                }
                
            }
            .padding(.horizontal)
            
        }
        .sheet(isPresented: $showAddCategoryView){
            AddCategoryView(onAddCategory: {newCategory in categories.append(newCategory)
            showAddCategoryView = false})
            
        }
        .frame(height: 120)
    }
}

