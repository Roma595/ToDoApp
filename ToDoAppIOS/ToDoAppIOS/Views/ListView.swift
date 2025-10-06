//
//  ListView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 17.09.2025.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @State var showAddView: Bool = false
    
    var body: some View {
        NavigationStack{
            TaskListView()
            .navigationTitle(Text("Список задач"))
            .toolbar{
                ListViewToolbar(showAddView: $showAddView)
            }
            .sheet(isPresented: $showAddView) {
                AddTaskView()
                    .interactiveDismissDisabled(true)
            }
        }
    }
}

#Preview {
    ListView()
}
