package com.example.todoappandroid

data class Task(
    val id: Long = System.currentTimeMillis(),
    val title: String,
    val description: String? = null,
    val date: String? = null,
    val category: String? = null,
    val reminder: Boolean = false,
    val isCompleted: Boolean = false
)

