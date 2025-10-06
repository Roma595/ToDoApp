//
//  AddToDoView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 17.09.2025.
//

import SwiftUI
import SwiftData

struct AddToDoView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskModel.id) private var tasks: [TaskModel]
    
    
    @State private var title: String = ""
    @State private var selectedDate: Date? = nil
    @State private var notificationDate: Date? = nil
    @State private var notificationTime: Date? = nil
    @State private var selectedCategory: CategoryModel? = nil
    @State private var note: String = ""
    
    @State private var showDatePicker: Bool = false
    @State private var setNotification: Bool = false
    @FocusState private var isFocusedText: Bool
    
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
                            .focused($isFocusedText)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                            
                    }
                    .toolbar{
                        ToolbarItemGroup(placement: .keyboard){
                            Spacer()
                            Button("Готово"){
                                isFocusedText = false
                                
                            }
                        
                        }
                    }
                    
                    // MARK: - Date Calendar
                    VStack(alignment: .leading, spacing: 15){
                        HStack{
                            Image(systemName: "calendar")
                                .foregroundStyle(.secondary)
                            Text("Дата")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                                
                        }
                        
                        if let date = selectedDate {
                            Text(dateFormatter.string(from: date))
                                            .foregroundColor(.blue)
                                            .onTapGesture { showDatePicker = true }
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(10)
                        } else {
                            Button(action: { showDatePicker = true;
                                }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Добавить дату")
                                }
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity, alignment: .center)
                            }.padding(10)
                        }
                    }
                    //MARK: - Notification
                    VStack(alignment: .leading, spacing: 15 ){
                        HStack{
                            Image(systemName: "bell")
                                .foregroundStyle(.secondary)
                            Text("Напоминание")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                        }
                        Button (action: {
                            setNotification = true
                            NotificationManager.shared.schedule(title: "test notification", body: "Тестируем напоминания гы гы", date: Date(timeIntervalSinceNow: 10))
                        }){
                            HStack {
                                Image(systemName: "plus")
                                Text("Добавить напоминание")
                            }
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }.padding(.vertical, 10)
                        
                        
                        
                        
                    }
                    //MARK: - Category Scroll
                    VStack(alignment: .leading, spacing: 15 ){
                        HStack{
                            Image(systemName: "paintbrush").foregroundStyle(.secondary)
                            Text("Категория")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        
                        CategoryScrollView()
                    
                    }
                    //MARK: - Text
                    VStack(alignment: .leading, spacing: 15 ){
                        HStack{
                            Image(systemName: "pencil")
                                .foregroundStyle(.secondary)
                            Text("Заметка")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                        }
                
                        TextEditor(text: $note)
                            .focused($isFocusedText)
                            .padding(.top, 4)
                            .frame(minHeight: 150)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .clipped()
                            .padding()
                    }
                    
                    //MARK: - //
                    
                    
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
                        let newTask = TaskModel(title: title, isCompleted: false, date: selectedDate, category: selectedCategory, note: note)
                        modelContext.insert(newTask)
                        try_save_context()
                        dismiss()
                    }
                }
            }
            //MARK: -DataPicker
            .sheet(isPresented: $showDatePicker) {
                NavigationStack{
                    VStack{
                        HStack{
                            Button(action: {
                                showDatePicker = false;
                                selectedDate = nil;
                            }){
                                Text("Отмена")
                            }
                            .padding(.leading, 12)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            
                            Button(action: {
                                showDatePicker = false;
                                
                            }){
                                Text("Добавить")
                            }
                            .padding(.trailing, 12)
                            
                            .frame(maxWidth: .infinity, alignment: .topTrailing)
                            
                        }
                        .padding(.top, 4)
                        
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
    }
    func try_save_context(){
        do {
            try modelContext.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
}

// MARK: - Preview
#Preview {
    AddToDoView()
}
