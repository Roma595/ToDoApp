package com.example.todoappandroid

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "tasks")
data class TaskEntity(
    @PrimaryKey
    val id: Long = System.currentTimeMillis(),  // Уникальный ID (автоматически)
    val title: String,                           // Название задачи
    val description: String? = null,             // Описание (может быть пусто)
    val date: String? = null,                    // Дата (может быть пусто)
    val category: String? = null,                // Категория (может быть пусто)
    val reminder: Boolean = false,               // Напоминание (да/нет)
    val isCompleted: Boolean = false             // Выполнено (да/нет)
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
