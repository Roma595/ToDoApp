//
//  AddNotificationView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 09.10.2025.
//

import SwiftUI

struct AddNotificationView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Ты получишь уведомление через 10 секунд")
            }
            .toolbar{
                AddNotificationViewToolbar()
            }
        }
        
    }
}

#Preview {
    AddNotificationView()
}
