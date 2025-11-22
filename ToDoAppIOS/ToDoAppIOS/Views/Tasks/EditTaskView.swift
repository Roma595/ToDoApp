//
//  EditTaskView.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 19.11.2025.
//

import SwiftUI
import SwiftData

struct EditTaskView: View {
    @State var task: TaskModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskModel.id) private var tasks: [TaskModel]
    @State private var activeSheet: AddToDoSheet?
    
    
    @State private var taskName: String
    @State private var selectedDate: Date?
    @State private var notificationDate: Date?
    @State private var notificationTime: Date?
    @State private var taskCategory: CategoryModel?
    @State private var taskNote: String
    
    @FocusState private var isFocusedText: Bool
    
    init(task: TaskModel) {
        self.task = task
        self.taskName = task.name
        self.selectedDate = task.date
        self.taskCategory = task.category
        self.taskNote = task.note ?? ""
    }
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Сохранить")
                    }
                }
            }
            //MARK: - Sheet
            .sheet(item: $activeSheet) {sheet in
                switch sheet {
                case .date:
                    DatePickerView(selectedDate: $selectedDate)
                        .presentationDetents([.medium])
                        .interactiveDismissDisabled(true)
                case .notification:
                    AddNotificationView()
                        .presentationDetents([.medium])
                        .interactiveDismissDisabled(true)
                case .category:
                    AddCategoryView()
                        .presentationDetents([.medium])
                        .interactiveDismissDisabled(true)
                }
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateStyle = .long
            return formatter
    }
}

//#Preview {
//    EditTaskView()
//}
    
