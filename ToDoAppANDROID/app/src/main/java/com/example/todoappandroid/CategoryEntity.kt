package com.example.todoappandroid

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "categories")
data class CategoryEntity(
    @PrimaryKey
    val name: String,     // Название категории (уникальное, как ключ)
    val color: String      // Цвет в формате #RRGGBB
)
// Функция для преобразования Entity в Model
fun CategoryEntity.toCategory() = Category(
    name = name,
    color = color
)

// Функция для преобразования Model в Entity
fun Category.toEntity() = CategoryEntity(
    name = name,
    color = color
)
