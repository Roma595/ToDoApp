package com.example.todoappandroid

import android.content.Context
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

object InitDatabase {
    fun addDefaultCategories(context: Context) {
        // Запускаем в фоновом потоке
        GlobalScope.launch(Dispatchers.IO) {
            val db = AppDatabase.getInstance(context)
            val dao = db.categoryDao()

            // Добавляем 4 дефолтные категории
            dao.insert(CategoryEntity("Работа", "#FF6B6B"))
            dao.insert(CategoryEntity("Дом", "#4ECDC4"))
            dao.insert(CategoryEntity("Учеба", "#45B7D1"))
            dao.insert(CategoryEntity("Личное", "#FFA07A"))

            Log.d("INIT_DB", "Дефолтные категории добавлены")
        }
    }
}
