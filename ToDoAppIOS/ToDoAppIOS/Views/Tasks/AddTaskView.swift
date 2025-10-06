//
//  AddToDoView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 17.09.2025.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskModel.id) private var tasks: [TaskModel]
    
    @State private var activeSheet: AddToDoSheet?
    
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
                        AddTaskFieldHeaderView(imageName: nil, headerName: "Заголовок")
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
                        AddTaskFieldHeaderView(imageName: "calendar", headerName: "Дата")
            
                        if let date = selectedDate {
                            Text(dateFormatter.string(from: date))
                                            .foregroundColor(.blue)
                                            .onTapGesture { showDatePicker = true }
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(10)
                        } else {
                            Button(action: {activeSheet = .date}) {
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
                        AddTaskFieldHeaderView(imageName: "bell", headerName: "Напоминание")
                        Button (action: {
                            activeSheet = .notification
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
                        AddTaskFieldHeaderView(imageName: "paintbrush", headerName: "Категория")
                        CategoryScrollView(activeSheet: $activeSheet)
                    
                    }
                    
                    //MARK: - Note
                    VStack(alignment: .leading, spacing: 15 ){
                        AddTaskFieldHeaderView(imageName: "pencil", headerName: "Заметка")
                
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
            //MARK: -Sheet
            .sheet(item: $activeSheet) {sheet in
                switch sheet {
                case .date:
                    DatePickerView(showDatePicker: $showDatePicker,  selectedDate: $selectedDate)
                case .notification:
                    Text("Notification")
                case .category:
                    Text("Category")
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
    AddTaskView()
}
