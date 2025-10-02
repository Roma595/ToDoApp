//
//  CategoryModel.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 18.09.2025.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class CategoryModel: Identifiable{
    @Attribute(.unique) var id: String = UUID().uuidString
    var name: String
    var colorHex: String
    
    init(name: String, color: Color) {
        self.name = name
        self.colorHex = color.toHex()
    }
    
    var color: Color {
        Color(hex: colorHex)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        if hex.count == 6 {
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        } else {
            r = 0; g = 0; b = 0
        }
        self.init(red: r, green: g, blue: b)
    }

    func toHex() -> String {
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        let rgb = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255)
        return String(format: "%06x", rgb)
    }
}

