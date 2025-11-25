//
//  WeekDaysHeaderView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 24.11.2025.
//

import SwiftUI

struct weekDaysHeader: View {
    
    var body: some View {
        HStack {
            ForEach(["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"], id: \.self) { day in
                Text(day)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
