//
//  AddView.swift
//  Todo
//
//  Created by Рома Котков on 13.09.2025.
//

import SwiftUI

struct AddView: View {
    
    @State var textFieldText: String = ""
    var body: some View {
        ScrollView{
            VStack{
                TextField("Напиши здесь что то...", text: $textFieldText)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                
                Button("Сохранить") {
                            
                }.padding(.horizontal)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(14)
        }
        .navigationTitle(Text("Добавить задачу"))
    }
}

#Preview {
    NavigationView{
        AddView()
    }
    
}
