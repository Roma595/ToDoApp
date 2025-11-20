package com.example.todoappandroid

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.sqlite.db.SupportSQLiteDatabase

@Database(
    entities = [TaskEntity::class, CategoryEntity::class],
    version = 1
)
abstract class AppDatabase : RoomDatabase() {

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
                    "todo_database"
                )
                    .addCallback(object : RoomDatabase.Callback() {
                        override fun onCreate(db: SupportSQLiteDatabase) {
                            super.onCreate(db)
                            // ⭐ Добавляем дефолтные категории при ПЕРВОМ создании БД
                            db.execSQL("INSERT INTO categories (name, color) VALUES ('Работа', '#FF6B6B')")
                            db.execSQL("INSERT INTO categories (name, color) VALUES ('Дом', '#4ECDC4')")
                            db.execSQL("INSERT INTO categories (name, color) VALUES ('Учеба', '#45B7D1')")
                            db.execSQL("INSERT INTO categories (name, color) VALUES ('Личное', '#FFA07A')")
                        }
                    })
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}
