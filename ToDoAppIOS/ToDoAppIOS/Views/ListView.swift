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
    @Query(sort: \TaskModel.completedValue) private var tasks: [TaskModel]
    
    @State var showAddView: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    ForEach(tasks){ task in
                        TaskItemView(task: task)
                    }
                }
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
}

#Preview {
    ListView()
}
