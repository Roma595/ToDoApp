package com.example.todoappandroid

data class Task(
    val id: Int = System.currentTimeMillis().toInt(),
    val title: String,
    val description: String? = null,
    val date: String? = null,
    val category: String? = null,
    val reminder: Boolean = false,
    val reminderDateTime: String? = null,
    val isCompleted: Boolean = false
)

