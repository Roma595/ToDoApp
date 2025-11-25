//
//  ProfileView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 17.09.2025.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack{
            VStack {
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)

                Text("Скоро здесь будет профиль")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding()            .navigationTitle(Text("Профиль"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileView()
}
