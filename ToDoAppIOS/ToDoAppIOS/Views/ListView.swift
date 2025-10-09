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
                .sheet(isPresented: $showAddView) {
                    AddTaskView()
                        .interactiveDismissDisabled(true)
                }
            }
            else{
                TaskListView()
                .navigationTitle(Text("Список задач"))
                .toolbar{
                    ListViewToolbar(showAddView: $showAddView)
                }
                .sheet(isPresented: $showAddView) {
                    AddTaskView()
                        .interactiveDismissDisabled(true)
                }
                .background(Color(.systemGray6)
                    .ignoresSafeArea())
            }
            
        }
    }
}

#Preview {
    ListView()
}
