//
//  AddTaskFieldHeaderView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 06.10.2025.
//

import SwiftUI

struct AddTaskFieldHeaderView: View {
    let imageName: String?
    let headerName: String
    var body: some View {
        HStack{
            if imageName != nil {
                Image(systemName: imageName!)
                    .foregroundStyle(.secondary)
            }
            Text(headerName)
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
                
        }
    }
}

