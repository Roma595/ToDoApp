//
//  TaskModel.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 02.10.2025.
//

import Foundation
import SwiftData

@Model
class TaskModel: Identifiable {
    @Attribute(.unique) var id: String = UUID().uuidString
    var name: String
    var isCompleted: Bool
    var date: Date?
    var category: CategoryModel?
    var note: String?
    
    var createdDate: Date
    
    init(name: String, isCompleted: Bool, date: Date? = nil, category: CategoryModel? = nil, note: String? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.isCompleted = isCompleted
        self.date = date
        self.category = category
        self.note = note
        self.createdDate = Date()
    }
}
