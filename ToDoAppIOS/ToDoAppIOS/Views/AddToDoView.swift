//
//  AddToDoView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 17.09.2025.
//

import SwiftUI

struct AddToDoView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var selectedDate: Date? = nil
    @State private var showDatePicker: Bool = false
    
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateStyle = .long
            return formatter
    }
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(alignment: .leading, spacing: 15){
                    // MARK: - Title
                    VStack{
                        Text("Заголовок")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("", text: $title)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                    }
                    // MARK: - Date Calendar
                    VStack(alignment: .leading, spacing: 15){
                        Text("Дата")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if let date = selectedDate {
                                        Text(dateFormatter.string(from: date))
                                            .foregroundColor(.blue)
                                            .onTapGesture { showDatePicker = true }
                                            .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Button(action: { showDatePicker = true }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Добавить дату")
                                }
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                    //MARK: - Category Scroll
                    VStack(alignment: .leading, spacing: 15 ){
                        Text("Категория")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CategoryScrollView()
                    
                    }
                    //MARK: - Reminder
                    
                    
                }
                
            }
            .padding(12)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button("Добавить") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showDatePicker) {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { selectedDate ?? Date() },
                        set: { selectedDate = $0 }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale(identifier: "ru_RU"))
                .presentationDetents([.medium])
            }
            
        }
    }
}

// MARK: - Preview
#Preview {
    AddToDoView()
}
