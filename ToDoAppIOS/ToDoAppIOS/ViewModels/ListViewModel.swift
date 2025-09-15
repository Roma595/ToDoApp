//
//  ListViewModel.swift
//  Todo
//
//  Created by Рома Котков on 13.09.2025.
//

import Foundation

class ListViewModel{
    
    @Published var items: [ItemModel] = []
    
    init(){
        getItems()
    }
    
    func getItems(){
        let newItems = [
            ItemModel(title: "Первая задача", isCompleted: false),
            ItemModel(title: "Вторая задача", isCompleted: true),
            ItemModel(title: "Третья задача", isCompleted: false)
        ]
        items.append(contentsOf: newItems)
    }
    
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func moveItem(from: IndexSet, to: Int){
        items.move(fromOffsets: from, toOffset: to)
    }
}
