//
//  ItemModel.swift
//  Todo
//
//  Created by Рома Котков on 13.09.2025.
//

import Foundation

struct ItemModel: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let isCompleted: Bool
}
