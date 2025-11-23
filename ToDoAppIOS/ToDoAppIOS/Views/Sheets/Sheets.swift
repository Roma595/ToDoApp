//
//  AddToDoSheet.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 06.10.2025.
//

import Foundation

enum AddToDoSheet: Identifiable{
    var id: Int {hashValue}
    case date, notification, category
}

enum CategorySheet: Identifiable{
    var id: Int {hashValue}
    case edit, delete
}
