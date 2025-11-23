package com.example.todoappandroid

import androidx.lifecycle.LiveData
import androidx.room.*

@Dao
interface CategoryDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(category: CategoryEntity)

    @Query("SELECT * FROM categories")
    fun getAllCategories(): LiveData<List<CategoryEntity>>

    @Delete
    suspend fun delete(category: CategoryEntity)

    @Query("DELETE FROM categories WHERE name = :name")
    suspend fun deleteByName(name: String)

    @Update
    suspend fun update(category:  CategoryEntity)
}
