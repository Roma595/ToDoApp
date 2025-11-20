package com.example.todoappandroid

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "tasks")
data class TaskEntity(
    @PrimaryKey
    val id: Long = System.currentTimeMillis(),
    val title: String,
    val description: String? = null,
    val date: String? = null,
    val category: String? = null,
    val reminder: Boolean = false,
    val isCompleted: Boolean = false
)

// Функция для преобразования Entity в Model
fun TaskEntity.toTask() = Task(
    id = id,
    title = title,
    description = description,
    date = date,
    category = category,
    reminder = reminder,
    isCompleted = isCompleted
)

// Функция для преобразования Model в Entity
fun Task.toEntity() = TaskEntity(
    id = id,
    title = title,
    description = description,
    date = date,
    category = category,
    reminder = reminder,
    isCompleted = isCompleted
)
