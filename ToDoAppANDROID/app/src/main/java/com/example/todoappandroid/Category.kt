package com.example.todoappandroid

data class Category(
    val id: Long = System.currentTimeMillis(),
    val name: String,
    val color: String  // Цвет в формате "#RRGGBB"
)