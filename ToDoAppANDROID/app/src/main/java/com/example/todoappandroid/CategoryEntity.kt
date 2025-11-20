package com.example.todoappandroid

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "categories")
data class CategoryEntity(
    @PrimaryKey
    val name: String,
    val color: String
)

fun CategoryEntity.toCategory() = Category(
    name = name,
    color = color
)

fun Category.toEntity() = CategoryEntity(
    name = name,
    color = color
)
