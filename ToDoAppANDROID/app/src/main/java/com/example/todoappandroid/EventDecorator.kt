package com.example.todoappandroid

import android.graphics.Color
import java.util.Calendar

class EventDecorator(
    private val datesWithTasks: Set<String>
) {
    fun hasTasks(year: Int, month: Int, day: Int): Boolean {
        val dateStr = String.format("%04d-%02d-%02d", year, month, day)
        return datesWithTasks.contains(dateStr)
    }
}
