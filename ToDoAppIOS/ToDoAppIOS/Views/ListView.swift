//
//  ListView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 17.09.2025.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskModel.name, order: .reverse) private var tasks: [TaskModel]
    
    @State var showAddView: Bool = false
    
    var body: some View {
        NavigationStack{
            if (tasks.isEmpty ){
                EmptyTasksView()
                    .toolbar{
                        ListViewToolbar(showAddView: $showAddView)
                            
                    }
                    .navigationTitle(Text("Список задач"))
                    .navigationBarTitleDisplayMode(.inline)
                    .sheet(isPresented: $showAddView) {
                        AddTaskView(showAddView: $showAddView)
                            .interactiveDismissDisabled(true)
                    }
            }
            else{
                TaskListView()
                    .toolbar{
                        ListViewToolbar(showAddView: $showAddView)
                    }
                    .navigationTitle(Text("Список задач"))
                    .navigationBarTitleDisplayMode(.inline)
                    //.navigationTitle(Text("Список задач"))
                    .sheet(isPresented: $showAddView) {
                        AddTaskView(showAddView: $showAddView)
                            .interactiveDismissDisabled(true)
                    }
                //.navigationTitle(Text("Список задач"))
            }
            
            
        }
    }
}

#Preview {
    ListView()
}
