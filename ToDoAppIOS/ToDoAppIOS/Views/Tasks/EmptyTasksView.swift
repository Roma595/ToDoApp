//
//  EmptyTasksView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 09.10.2025.
//

import SwiftUI

struct EmptyTasksView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.gray)

            Text("Нет задач на этот день")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    EmptyTasksView()
}
