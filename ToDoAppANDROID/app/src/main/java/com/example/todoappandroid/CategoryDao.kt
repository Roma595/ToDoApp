package com.example.todoappandroid

import androidx.lifecycle.LiveData
import androidx.room.*

@Dao
interface CategoryDao {

    // ⭐ Добавить одну категорию в БД
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(category: CategoryEntity)

    // ⭐ Получить все категории (как живой список — обновляется автоматически)
    @Query("SELECT * FROM categories")
    fun getAllCategories(): LiveData<List<CategoryEntity>>

    // ⭐ Удалить категорию
    @Delete
    suspend fun delete(category: CategoryEntity)
}
