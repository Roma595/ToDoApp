//
//  ListViewToolbar.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 06.10.2025.
//

import SwiftUI

struct ListViewToolbar: ToolbarContent {
    @Binding var showAddView: Bool

    var body: some ToolbarContent {
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showAddView = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}
