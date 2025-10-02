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
    var title: String
    var isCompleted: Bool
    var date: Date
    //var notification
    var category: CategoryModel?
    var note: String?
    
    init(title: String, isCompleted: Bool, date: Date, category: CategoryModel? = nil, note: String? = nil) {
        self.title = title
        self.isCompleted = isCompleted
        self.date = date
        self.category = category
        self.note = note
    }
}
