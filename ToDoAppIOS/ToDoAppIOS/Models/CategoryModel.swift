//
//  CategoryModel.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 18.09.2025.
//

import Foundation
import SwiftUI

struct CategoryModel: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}
