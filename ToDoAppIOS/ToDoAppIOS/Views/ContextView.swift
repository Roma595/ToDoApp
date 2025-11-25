//
//  ContextView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 17.09.2025.
//

import SwiftUI

struct ContextView: View {
    @State private var selectedTabIndex: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            Tab("Задачи", systemImage: "list.bullet",  value: 0){
                ListView()
            }
            Tab("Календарь", systemImage: "calendar", value: 1){
                CalendarView()
            }
            Tab("Профиль", systemImage: "person", value: 2){
                ProfileView()
            }
        }
    }
}

#Preview {
    ContextView()
}
