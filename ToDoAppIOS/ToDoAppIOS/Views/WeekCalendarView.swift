import SwiftUI

struct WeekCalendarView: View {
    @Binding var selectedDate: Date
    @State private var currentWeekStart: Date = Date().startOfWeek()
    
    let calendar = Calendar.current
    
    var weekDays: [Date] {
        (0...6).compactMap { calendar.date(byAdding: .day, value: $0, to: currentWeekStart) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Месяц и кнопка смены месяца
            HStack {
                Text(monthYearString(for: currentWeekStart))
                    .font(.title2).bold()
                Spacer()
                Button(action: { updateWeek(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                Button(action: { updateWeek(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Дни недели
            HStack {
                ForEach(weekDays, id: \.self) { date in
                    VStack {
                        Text(shortWeekdayString(for: date))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("\(calendar.component(.day, from: date))")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(isSelected(date) ? .white : .primary)
                            .frame(width: 36, height: 36)
                            .background(isSelected(date) ? Color.blue : Color.clear)
                            .clipShape(Circle())
                    }
                    .onTapGesture {
                        selectedDate = date
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                .background(Color.white.cornerRadius(20))
        )
        .padding(.horizontal)
    }
    
    // MARK: - Helpers
    
    func monthYearString(for date: Date) -> String {
        let df = DateFormatter()
        df.locale = .current
        df.dateFormat = "LLLL yyyy"
        return df.string(from: date)
    }
    
    func shortWeekdayString(for date: Date) -> String {
        let df = DateFormatter()
        df.locale = .current
        df.dateFormat = "E"
        return df.string(from: date)
    }
    
    func isSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    func updateWeek(by value: Int) {
        if let updated = calendar.date(byAdding: .weekOfYear, value: value, to: currentWeekStart) {
            currentWeekStart = updated.startOfWeek()
        }
    }
}

// MARK: - Extension

extension Date {
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
}

// MARK: - Пример использования:

struct WeekCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WeekCalendarView(selectedDate: .constant(Date()))
    }
}

#Preview {
    WeekCalendarView(selectedDate: .constant(Date()))
}
