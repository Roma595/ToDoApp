package com.example.todoappandroid

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(
    entities = [TaskEntity::class, CategoryEntity::class],  // ← Какие таблицы будут
    version = 1,                                             // ← Версия БД
    exportSchema = false
)
abstract class AppDatabase : RoomDatabase() {

    // ← Методы для получения DAO
    abstract fun taskDao(): TaskDao
    abstract fun categoryDao(): CategoryDao

    companion object {
        @Volatile
        private var INSTANCE: AppDatabase? = null

        fun getInstance(context: Context): AppDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    AppDatabase::class.java,
                    "todo_database"  // ← Имя файла БД
                )
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}
