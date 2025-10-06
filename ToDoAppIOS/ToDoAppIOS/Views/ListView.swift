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
    @Query(sort: \TaskModel.createdDate, order: .reverse) private var tasks: [TaskModel]
    
    @State var showAddView: Bool = false
    
    var activeTasks: [TaskModel] {
        tasks.filter { !$0.isCompleted }
    }

    var completedTasks: [TaskModel] {
        tasks.filter { $0.isCompleted }
    }
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Активные задачи")) {
                    ForEach(activeTasks) { task in
                        TaskItemView(task: task)
                    }
                }
                            
                Section(header: Text("Выполненные задачи")) {
                    ForEach(completedTasks) { task in
                        TaskItemView(task: task)
                    }
                }
            }
            .animation(.default, value: tasks)
            .navigationTitle(Text("Список"))
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        showAddView = true
                    }label: {
                        Image(systemName:"plus")
                    }
                }
            }
            .sheet(isPresented: $showAddView) {
                AddToDoView()
            }
        }
    }
}

#Preview {
    ListView()
}
