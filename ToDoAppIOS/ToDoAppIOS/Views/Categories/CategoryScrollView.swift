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
    @State private var selectedIndex: Int? = nil
    @State private var isSelectedCategory: Bool = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(Array(categories.enumerated().reversed()), id: \.element.id){
                    (index, category) in
                    VStack{
                        Circle()
                            .fill(category.color)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .stroke(selectedIndex == index ? Color.blue : Color.clear, lineWidth: 4)
                            )
                            .scaleEffect(selectedIndex == index ? 1.1 : 1)
                            .animation(.spring(), value: selectedIndex)
                            .onTapGesture {
                                if (selectedIndex == index){
                                    selectedIndex = nil
                                }
                                else{
                                    selectedIndex = index
                                }
                                
                            }
                        Text(category.name)
                            .font(.caption)
                    }
                }
//
                
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

