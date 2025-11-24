//
//  ListViewToolbar.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 06.10.2025.
//

import SwiftUI
import SwiftData

struct ListViewToolbar: ToolbarContent {
    @Binding var showAddView: Bool
    
    @State var selectedCategory: CategoryModel?
    @Query(sort: \CategoryModel.name) private var categories: [CategoryModel]
    
    var body: some ToolbarContent {
        
//        ToolbarItemGroup(placement: .topBarLeading) {
//                            Button("Draw", systemImage: "pencil") {
//                                // Button action here
//                            }
//                            
//                            Button("Erase", systemImage: "eraser") {
//                                // Button action here
//                            }
//                        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showAddView = true
            } label: {
                Image(systemName: "plus")
            }
            
        }
    }
}
    

