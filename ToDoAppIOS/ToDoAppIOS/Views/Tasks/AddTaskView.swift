//
//  AddTaskView.swift
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
    @State private var showAlert = false
    
    @State private var taskName: String = ""
    @State private var selectedDate: Date? = nil
    @State private var notificationDateTime: Date? = nil
    @State private var taskCategory: CategoryModel? = nil
    @State private var taskNote: String = ""
    
    let notificationMessage: String = "Не забудь выполнить задачу. Скорее посмотри ее!"
    
    @FocusState private var isFocusedText: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(alignment: .leading, spacing: 15){
                    // MARK: - taskName
                    TextField("Название задачи", text: $taskName)
                        .font(.title2)
                        .focused($isFocusedText)
                        .submitLabel(.done)
                        .onSubmit {isFocusedText.toggle()}
                        .padding(10)

                
                    // MARK: - Date Calendar
                    VStack(alignment: .leading, spacing: 15){
                        AddTaskFieldHeaderView(imageName: "calendar", headerName: "Дата")
            
                        if let date = selectedDate {
                            Text(dateFormatter.string(from: date))
                                            .foregroundColor(.blue)
                                            .onTapGesture { activeSheet = .date}
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(10)
                        } else {
                            Button(action: {activeSheet = .date
                            selectedDate = Date()}) {
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
                        
                        if let datetime = notificationDateTime {
                            Text(dateFormatterNotification.string(from: datetime))
                                            .foregroundColor(.blue)
                                            .onTapGesture { activeSheet = .notification}
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(10)
                        }
                        else{
                            Button (action: {
                                activeSheet = .notification
                            }){
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Добавить напоминание")
                                }
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity, alignment: .center)
                            }.padding(.vertical, 10)
                        }
                        
                    }
                    
                    //MARK: - Category Scroll
                    VStack(alignment: .leading, spacing: 15 ){
                        AddTaskFieldHeaderView(imageName: "paintbrush", headerName: "Категория")
                    
                        CategoryScrollView(activeSheet: $activeSheet, selectedCategory: $taskCategory)
                            
                    }
                    
                    //MARK: - Note
                    VStack(alignment: .leading, spacing: 15 ){
                        AddTaskFieldHeaderView(imageName: "pencil", headerName: "Заметка")
                        
                        
                        TextEditor(text: $taskNote)
                            .frame(minHeight: 150)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .focused($isFocusedText)
                            .padding(15)
                    }
                }
            }
            //MARK: - Toolbar
            .padding(12)
            .toolbar {
                AddTaskToolbar(showAlert: $showAlert, add_new_task: add_new_task)
            }
            //MARK: - Sheet
            .sheet(item: $activeSheet) {sheet in
                switch sheet {
                case .date:
                    DatePickerView(selectedDate: $selectedDate)
                        .presentationDetents([.height(450)])
                        .interactiveDismissDisabled(true)
                case .notification:
                    NotificationDatePickerView(selectedDateTime: $notificationDateTime)
                        .presentationDetents([.height(500)])
                        .interactiveDismissDisabled(true)
                case .category:
                    AddCategoryView()
                        .presentationDetents([.height(300)])
                        .interactiveDismissDisabled(true)
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
    
    func add_new_task(){
        if taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert = true
            return
        }
        let newTask = TaskModel(name: taskName, isCompleted: false, date: selectedDate, notificationDateTime: notificationDateTime, category: taskCategory, note: taskNote)
        modelContext.insert(newTask)
        
        if (notificationDateTime != nil){
            NotificationManager.shared.schedule(title: newTask.name, body: notificationMessage, date: notificationDateTime!, taskId: newTask.id)
        }
        try_save_context()
    }
    
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateStyle = .long
            return formatter
    }
    private var dateFormatterNotification: DateFormatter {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "dd MMMM 'в' HH:mm"
            return formatter
    }
    
}

// MARK: - Preview
#Preview {
    AddTaskView()
}
