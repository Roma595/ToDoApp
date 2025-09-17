//
//  ListView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 17.09.2025.
//

import SwiftUI

struct ListView: View {
    
    @State var showAddView: Bool = false
    
    var body: some View {
        NavigationStack{
            List{
                
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

#Preview {
    ListView()
}
