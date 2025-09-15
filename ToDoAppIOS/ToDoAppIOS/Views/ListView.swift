//
//  ListView.swift
//  Todo
//
//  Created by Рома Котков on 13.09.2025.
//

import SwiftUI

struct ListView: View {
    
    @State var items: [ItemModel] = [
            ItemModel(title: "Первая задача", isCompleted: false),
            ItemModel(title: "Вторая задача", isCompleted: true),
            ItemModel(title: "Третья задача", isCompleted: false)
        ]

    var body: some View {
        List{
            ForEach(items){
                item in ListRowView(item: item)
                
            }
            .onDelete(perform: deleteItem)
            .onMove(perform: moveItem)
        }
        .navigationTitle("Список дел")
        .navigationBarItems(leading: EditButton(), trailing: NavigationLink("Добавить", destination: AddView()))
    }
    
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func moveItem(from: IndexSet, to: Int){
        items.move(fromOffsets: from, toOffset: to)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView()
        }
        
    }
}

