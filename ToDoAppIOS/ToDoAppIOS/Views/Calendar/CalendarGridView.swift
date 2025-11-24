//
//  CalendarGridView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 24.11.2025.
//

import SwiftUI
import SwiftData

struct CalendarGridView: View {
    @Query(sort: \TaskModel.id) private var tasks: [TaskModel]
    
    @Binding var selectedDate: Date
    @State private var currentMonth = Date()

    var body: some View {
        VStack(spacing: 8) {
            weekDaysHeader()
            
            let days = getDaysInMonth(currentMonth)
            let firstWeekday = getFirstWeekday(currentMonth)
            
            VStack(spacing: 8) {
                ForEach(0..<Int(ceil(Double(days.count + firstWeekday) / 7)), id: \.self) { week in
                    HStack(spacing: 8) {
                        ForEach(0..<7, id: \.self) { day in
                            let index = week * 7 + day - firstWeekday

                            if index >= 0 && index < days.count {
                                let date = days[index]
                                let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                                //let taskCount = getTaskCount(for: date)

                                ZStack(alignment: .bottomTrailing) {
                                    VStack {
                                        Text("\(Calendar.current.component(.day, from: date))")
                                            .font(.system(.body, design: .default))
                                            .fontWeight(isSelected ? .bold : .regular)
                                            .foregroundColor(isSelected ? .white : .black)
                                        
                                        //Spacer()
                                    }
                                    
                                    // Индикатор количества задач
//                                    if taskCount > 0 {
//                                        Circle()
//                                            .fill(Color.blue)
//                                            .frame(width: 18, height: 18)
//                                            .overlay(
//                                                Text("\(taskCount)")
//                                                    .font(.caption2)
//                                                    .fontWeight(.bold)
//                                                    .foregroundColor(.white)
//                                            )
//                                    }
                                }
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(isSelected ? Color.blue : Color(.systemGray6))
                                .cornerRadius(8)
                                .onTapGesture {
                                    withAnimation {
                                        selectedDate = date
                                    }
                                }
                            } else {
                                Color.clear
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func getTaskCount(for date: Date) -> Int {
        tasks.filter { Calendar.current.isDate($0.date!, inSameDayAs: date) }.count
    }

    private func getDaysInMonth(_ date: Date) -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let days = range.count

        var result: [Date] = []
        for day in 1...days {
            var components = calendar.dateComponents([.year, .month], from: date)
            components.day = day
            if let date = calendar.date(from: components) {
                result.append(date)
            }
        }
        return result
    }
    
    private func getFirstWeekday(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: date)
        let firstDay = calendar.date(from: components)!
        let weekday = calendar.component(.weekday, from: firstDay)
        return weekday == 1 ? 6 : weekday - 2
    }
}

