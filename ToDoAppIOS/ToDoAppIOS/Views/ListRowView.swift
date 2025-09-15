//
//  ListRowView.swift
//  Todo
//
//  Created by Рома Котков on 13.09.2025.
//

import SwiftUI

struct ListRowView: View {
    
    let item: ItemModel
    var body: some View {
        HStack{
            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(item.isCompleted ? .green : .red)
            Text(item.title)
            Spacer()
        }.font(.title2)
            .padding(.vertical, 6)
    }
}

#Preview {
    var item1 = ItemModel(title: "Test1", isCompleted: true)
    ListRowView(item: item1)
}
