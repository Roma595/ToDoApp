package com.example.todoappandroid

import androidx.lifecycle.LiveData
import androidx.room.*

@Dao
interface TaskDao {

    // ⭐ Добавить задачу
    @Insert
    suspend fun insert(task: TaskEntity)

    // ⭐ Обновить задачу
    @Update
    suspend fun update(task: TaskEntity)

    // ⭐ Удалить задачу
    @Delete
    suspend fun delete(task: TaskEntity)

    // ⭐ Получить все задачи
    @Query("SELECT * FROM tasks")
    fun getAllTasks(): LiveData<List<TaskEntity>>
}
